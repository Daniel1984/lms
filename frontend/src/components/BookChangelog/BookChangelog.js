import React from 'react'
import PropTypes from 'prop-types'
import cn from 'classnames'
import InfoBox from '../Common/InfoBox/InfoBox'
import css from './BookChangelog.module.scss'

const BookChangelog = ({ changelog }) => {
  if (!changelog.length) {
    return <InfoBox>No changes</InfoBox>
  }

  const titles = Object.keys(changelog[0])

  return (
    <div className={css.root}>
      <div className={cn(css.row, css.heading)}>
        {titles.map(title => (
          <div key={title} className={css.col}>{title}</div>
        ))}
      </div>

      {changelog.map((cl, idx) => (
        <div key={`cl-${idx}`} className={css.row}>
          {titles.map((title, idx) => (
            <div key={`${title}-${idx}`} className={css.col}>
              {cl[title]}
            </div>
          ))}
        </div>
      ))}
    </div>
  )
}

BookChangelog.propTypes = {
  changelog: PropTypes.arrayOf(PropTypes.shape({
    title: PropTypes.string,
    author: PropTypes.string,
    description: PropTypes.string,
    isbn: PropTypes.string,
  })),
}

BookChangelog.defaultProps = {
  changelog: [],
}

export default BookChangelog
