package de.saumya.lucene;

import java.io.File;
import java.io.IOException;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

public class LuceneService {

    private final File indexDir;

    public LuceneService(final File indexDir) {
        this.indexDir = indexDir;
    }

    public LuceneIndexer createIndexer() throws IOException {
        return new LuceneIndexer(new IndexWriter(FSDirectory.open(this.indexDir),
                new StandardAnalyzer(Version.LUCENE_CURRENT),
                !this.indexDir.exists(),
                IndexWriter.MaxFieldLength.LIMITED),
                IndexReader.open(FSDirectory.open(this.indexDir), true));
    }

    public LuceneReader createReader() throws CorruptIndexException,
            IOException {
        return new LuceneReader(new IndexSearcher(FSDirectory.open(this.indexDir),
                true));
    }

    public LuceneDeleter createDeleter() throws CorruptIndexException,
            IOException {
        return new LuceneDeleter(IndexReader.open(FSDirectory.open(this.indexDir),
                                                  false));
    }
}
