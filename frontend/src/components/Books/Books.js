import React, { Component } from 'react'
import PropTypes from 'prop-types'
import { getBooks } from '../../api/book'
import InfoBox from '../Common/InfoBox/InfoBox'
import Spinner from '../Common/Spinner/Spinner'
import Headline from '../Common/Headline/Headline'
import BookList from './BookList'
import css from './Books.module.scss'

export class Books extends Component {
  state = {
    error: '',
    loading: false,
    books: []
  }

  componentDidMount() {
    console.log('fetching books')
    this.setState({ loading: true }, async () => {
      try {
        const books = await getBooks()
        this.setState({
          loading: false,
          books
        })
      } catch (err) {
        this.setState({
          loading: false,
          error: err.message
        })
      }
    })
  }

  render() {
    const { error, loading, books } = this.state
    return (
      <div className={css.root}>
        <Headline>
          Library Management System
        </Headline>

        {loading && (
          <Spinner message="Loading books..."/>
        )}

        {error && (
          <InfoBox type="alert">
            {error}
          </InfoBox>
        )}

        {(!error && !loading && !books.length) && (
          <InfoBox>No books added yet</InfoBox>
        )}

        {(!error && !loading && books.length > 0) && (
          <BookList books={books} />
        )}
      </div>
    )
  }
}

Books.propTypes = {
  books: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string,
    title: PropTypes.string,
    author: PropTypes.string,
    description: PropTypes.string,
    isbn: PropTypes.string,
    changelog: PropTypes.arrayOf(PropTypes.shape({}))
  })),
}

Books.defaultProps = {
  books: [],
}

export default Books
