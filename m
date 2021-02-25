Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44766C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 14:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E433E64F06
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 14:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhBYOZ4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 09:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:54436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhBYOZz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 09:25:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA51D64F06;
        Thu, 25 Feb 2021 14:25:13 +0000 (UTC)
Date:   Thu, 25 Feb 2021 09:25:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jacob Wen <jian.w.wen@oracle.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210225092511.03c0034c@gandalf.local.home>
In-Reply-To: <aeedc1c3-9cd3-150e-aa63-29b4efcb43c2@oracle.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
        <20210224210302.0e0a196a@oasis.local.home>
        <aeedc1c3-9cd3-150e-aa63-29b4efcb43c2@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 15:06:08 +0800
Jacob Wen <jian.w.wen@oracle.com> wrote:

> I don't have time to fix and test it today.

OK, I'll write something up today.

Thanks,

-- Steve
