import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { withRouter } from 'react-router-dom'
import { getBook } from '../../api/book'
import Spinner from '../Common/Spinner/Spinner'
import InfoBox from '../Common/InfoBox/InfoBox'
import Center from '../Common/Center/Center'
import Headline from '../Common/Headline/Headline'
import BookForm from '../BookForm/BookForm'
import BookChangelog from '../BookChangelog/BookChangelog'
import css from './Book.module.scss'

export class Book extends Component {
  state = {
    loading: false,
    error: '',
    book: {}
  }

  componentDidMount() {
    const {
      match: { params: { id, author } },
      location: { book }
    } = this.props

    const haveBook = book && Object.keys(book).length
    // in case we edit prefetched book, we persist it to state
    if (haveBook) {
      this.setState({ book })
      return
    }

    // if url params contain id but book is not in state, we fetch it
    if (id && author && !book) {
      this.setState({ loading: true }, async () => {
        try {
          const { data: books } = await getBook(id, author)
          const respBook = books.filter(b => b.id === id && b.author === author)

          if (respBook.length) {
            this.setState({
              loading: false,
              book: respBook[0],
            })
            return
          }

          this.setState({
            loading: false,
            book: null,
            error: 'book not found'
          })
        } catch (err) {
          this.setState({
            loading: false,
            error: err.message
          })
        }
      })
    }
  }

  render() {
    const { loading, error, book } = this.state

    return (
      <div className={css.root}>
        {loading && (
          <Center>
            <Spinner message="Loading book data..."/>
          </Center>
        )}

        {error && (
          <Center>
            <InfoBox type="alert">
              <div className={css.error}>
                {error}
              </div>
            </InfoBox>
          </Center>
        )}

        {(!error && !loading && book) && (
          <>
            <div key={"abc"} className={css.col}>
              <Headline>
                {book.title ? 'Edit book' : 'Insert New Book'}
              </Headline>
              <BookForm book={book} />
            </div>

            <div key={"def"} className={css.col}>
              <Headline>
                Changelog
              </Headline>
              <BookChangelog changelog={book.changelog} />
            </div>
          </>
        )}
      </div>
    )
  }
}

Book.propTypes = {
  match: PropTypes.shape({
    params: PropTypes.shape({
      merchantId: PropTypes.string,
    }),
  }).isRequired,
  location: PropTypes.shape({
    book: PropTypes.shape({})
  })
}

Book.defaultProps = {
  location: {
    book: {}
  }
}

export default withRouter(Book)
