Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9088EE7C4D0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 15:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjJDPI7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbjJDPI6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 11:08:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04503BD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 08:08:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16380C433C9;
        Wed,  4 Oct 2023 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696432134;
        bh=pStkvGE8dEk8xz7y4JnC4P2926RLXj9PtaWywM4hYfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPL4XZN7GdD7lrL5/XIVtRGoeXDQu6wfFXm4DUp2vUjLuofhTufxOgDMSgVbLFvdy
         +sG0n7AP+RJpGLZifaFCPlKKgS/C7YrQL+AQ6WLHSi95vVYJuyJKkBelR9ucQMUGHR
         EqyfRMZaDNLCy/HIX3SxhldQB+5YdIsCC1/27ZlXhuNHgzUnsBWOUkNaq7KPsqSCV3
         TetI6kdIPz0xGxcocQPB06bZI+hEceYu7/MfFSDyV9P5ojAkvXbg2nhD+1EVHwFZwH
         qyGcX6yMsd/MaAe/DsViCt10AX1Ay1rEOzPwjxok5HfgIuGCZYRO/e0MW/8xwNX0f8
         d+dUFiB1ctL5A==
Date:   Wed, 4 Oct 2023 08:08:52 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Andrew Morton' <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [failures] compilerh-move-__is_constexpr-to-compilerh.patch
 removed from -mm tree
Message-ID: <20231004150852.GA2580510@dev-arch.thelio-3990X>
References: <20231003234225.15C03C433C7@smtp.kernel.org>
 <e82afc60ad0741a99c0980cb17b3679a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e82afc60ad0741a99c0980cb17b3679a@AcuMS.aculab.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Oct 04, 2023 at 08:14:53AM +0000, David Laight wrote:
> From: Andrew Morton
> > Sent: 04 October 2023 00:42
> > 
> > 
> > The quilt patch titled
> >      Subject: compiler.h: move __is_constexpr() to compiler.h
> > has been removed from the -mm tree.  Its filename was
> >      compilerh-move-__is_constexpr-to-compilerh.patch
> > 
> > This patch was dropped because it had testing failures
> 
> Any hint as to where?

You were CC'd on the report it seems:

https://lore.kernel.org/20231004095058.392f8c17@canb.auug.org.au/

Cheers,
Nathan
