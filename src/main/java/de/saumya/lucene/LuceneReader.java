/**
 * 
 */
package de.saumya.lucene;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.StaleReaderException;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.Searcher;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.search.WildcardQuery;
import org.apache.lucene.store.LockObtainFailedException;

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

    public Collection<Map<String, String>> readAll()
            throws StaleReaderException, CorruptIndexException,
            LockObtainFailedException, IOException {
        final Query query = new WildcardQuery(new Term("id", "*"));
        final TopDocs docs = this.searcher.search(query, 1200000);
        final Set<Map<String, String>> result = new HashSet<Map<String, String>>();
        for (final ScoreDoc sdoc : docs.scoreDocs) {
            final Map<String, String> map = new HashMap<String, String>();
            final Document doc = this.searcher.doc(sdoc.doc);
            for (final Object o : doc.getFields()) {
                final Field f = (Field) o;
                map.put(f.name(), f.stringValue());
            }
            result.add(map);
        }
        return result;
    }

    public void close() throws IOException {
        this.searcher.close();
    }
}