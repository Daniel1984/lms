import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import { Link } from 'react-router-dom'
import css from './BookList.module.scss'

const BookList = ({ books }) => {
  const titles = Object.keys(books[0])

  return (
    <div className={css.root}>
      <div className={cn(css.row, css.heading)}>
        {titles.map(title => (
          <div key={title} className={css.col}>{title}</div>
        ))}
        <div className={css.col}>actions</div>
      </div>

      {books.map(book => (
        <div key={book.id} className={css.row}>
          {titles.map((title, idx) => (
            <div key={`${title}-${idx}`} className={css.col}>
              {title === 'changelog' ? book[title].length : book[title]}
            </div>
          ))}
          <div className={css.col}>
            <Link to={{ pathname: `/books/${book.id}`, book }}>
              Edit
            </Link>
          </div>
        </div>
      ))}
    </div>
  )
}

 BookList.propTypes = {
  books: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.string,
    title: PropTypes.string,
    author: PropTypes.string,
    description: PropTypes.string,
    isbn: PropTypes.string,
    changelog: PropTypes.arrayOf(PropTypes.shape({}))
  })),
}

export default BookList
