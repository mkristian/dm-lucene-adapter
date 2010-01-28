/**
 * 
 */
package de.saumya.lucene;

import java.io.IOException;
import java.util.Map;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;

public class LuceneIndexer {

    private final IndexWriter writer;

    private final IndexReader reader;

    LuceneIndexer(final IndexWriter writer, final IndexReader reader) {
        this.writer = writer;
        this.reader = reader;
    }

    public void index(final Map<String, String> resource)
            throws CorruptIndexException, IOException {
        final Document document = new Document();
        for (final Map.Entry<String, String> entry : resource.entrySet()) {
            if (entry.getValue() != null) {
                document.add(new Field(entry.getKey(),
                        entry.getValue(),
                        Field.Store.YES,
                        Field.Index.ANALYZED));
            }
        }
        this.writer.addDocument(document);
    }

    public void close() throws CorruptIndexException, IOException {
        try {
            this.writer.optimize();
            this.writer.close();
        }
        finally {
            this.reader.close();
        }
    }
}