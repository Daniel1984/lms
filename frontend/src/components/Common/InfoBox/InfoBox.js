import React from 'react'
import cn from 'classnames'
import PropTypes from 'prop-types'
import css from './InfoBox.module.scss'

const InfoBox = ({ type = 'info', children }) => (
  <div className={cn(css.root, css[type])}>
    {children}
  </div>
)

InfoBox.propTypes = {
  type: PropTypes.oneOf(['info', 'alert', 'success']),
  children: PropTypes.node.isRequired,
}

InfoBox.defaultProps = {
  type: 'info',
}

export default InfoBox
