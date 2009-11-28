/**
 * 
 */
package de.saumya.lucene;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.StaleReaderException;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Searcher;
import org.apache.lucene.search.Sort;
import org.apache.lucene.search.SortField;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.WildcardQuery;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.store.LockObtainFailedException;
import org.apache.lucene.util.Version;

public class LuceneReader {

    private final Searcher searcher;

    LuceneReader(final Searcher searcher) {
        this.searcher = searcher;
    }

    public Map<String, String> read(final int id) throws StaleReaderException,
            CorruptIndexException, LockObtainFailedException, IOException {
        final Query query = new TermQuery(new Term("id", id + ""));
        final TopDocs docs = this.searcher.search(query, 1200000);
        final Map<String, String> result = new HashMap<String, String>();
        for (final ScoreDoc sdoc : docs.scoreDocs) {
            final Document doc = this.searcher.doc(sdoc.doc);
            for (final Object o : doc.getFields()) {
                final Field f = (Field) o;
                result.put(f.name(), f.stringValue());
            }
        }
        return result;
    }

    public Collection<Map<String, String>> readAll(final int offset,
            final int limit) throws StaleReaderException,
            CorruptIndexException, LockObtainFailedException, IOException {
        final Query query = new WildcardQuery(new Term("id", "*"));
        return readAll(offset, limit, query);
    }

    private Collection<Map<String, String>> readAll(final int offset,
            int limit, final Query query) throws IOException,
            CorruptIndexException {
        final TopDocs docs = this.searcher.search(query,
                                                  null,
                                                  1000000,
                                                  new Sort(new SortField("id",
                                                          SortField.INT)));
        final List<Map<String, String>> result = new ArrayList<Map<String, String>>();
        int index = 0;
        for (final ScoreDoc sdoc : docs.scoreDocs) {
            if (index >= offset) {
                final Map<String, String> map = new HashMap<String, String>();
                final Document doc = this.searcher.doc(sdoc.doc);
                for (final Object o : doc.getFields()) {
                    final Field f = (Field) o;
                    map.put(f.name(), f.stringValue());
                }
                result.add(map);
                limit--;
                if (limit == 0) {
                    break;
                }
            }
            index++;
        }
        return result;
    }

    public Collection<Map<String, String>> readAll(final int offset,
            final int limit, final String query) throws StaleReaderException,
            CorruptIndexException, LockObtainFailedException, IOException,
            ParseException {
        final QueryParser parser = new QueryParser(Version.LUCENE_CURRENT,
                "id",
                new StandardAnalyzer(Version.LUCENE_CURRENT));
        if (query.startsWith("NOT ")) {
            final Query query3 = new WildcardQuery(new Term("id", "*"));
            final BooleanQuery query2 = new BooleanQuery();
            query2.add(query3, Occur.MUST);
            query2.add(parser.parse(query.substring(4)), Occur.MUST_NOT);
            return readAll(offset, limit, query2);
        }
        else {
            return readAll(offset, limit, parser.parse(query));
        }
    }

    public void close() throws IOException {
        this.searcher.close();
    }
}