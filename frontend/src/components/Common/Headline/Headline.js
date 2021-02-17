import React from 'react'
import PropTypes from 'prop-types'
import css from './Headline.module.scss'

const Headline = ({ children }) => (
  <div className={css.root}>
    {children}
  </div>
)

Headline.propTypes = {
  children: PropTypes.node.isRequired,
}

export default Headline
