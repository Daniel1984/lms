import React from 'react'
import css from './Page404.module.scss'

const Page404 = () => (
  <div className={css.root}>
    <div className={css.content}>
      <div className={css.title}>
        404
      </div>
      <div className={css.message}>
        The page you`re looking for may have been removed, had a name change, is temporarily unavailabe or non existing.
      </div>
      <a className={css.link} href="/">
        Visit Home Page
      </a>
    </div>
  </div>
)

export default Page404
