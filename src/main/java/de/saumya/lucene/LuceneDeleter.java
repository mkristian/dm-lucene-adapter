/**
 * 
 */
package de.saumya.lucene;

import java.io.IOException;

import org.apache.lucene.index.CorruptIndexException;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.StaleReaderException;
import org.apache.lucene.index.Term;
import org.apache.lucene.index.TermDocs;
import org.apache.lucene.store.LockObtainFailedException;

public class LuceneDeleter {

    private final IndexReader reader;

    LuceneDeleter(final IndexReader reader) {
        this.reader = reader;
    }

    public void delete(final int id) throws StaleReaderException,
            CorruptIndexException, LockObtainFailedException, IOException {
        final TermDocs terms = this.reader.termDocs(new Term("id", "" + id));
        while (terms.next()) {
            this.reader.deleteDocument(terms.doc());
        }
        terms.close();
    }

    public void close() throws CorruptIndexException, IOException {
        this.reader.close();
    }
}