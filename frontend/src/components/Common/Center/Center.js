import React from 'react'
import PropTypes from 'prop-types'
import css from './Center.module.scss'

const Center = ({ children }) => (
  <div className={css.root}>
    {children}
  </div>
)

Center.propTypes = {
  children: PropTypes.node.isRequired,
}

export default Center
