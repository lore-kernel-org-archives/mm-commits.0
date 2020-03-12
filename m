From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mm-gup-track-foll_pin-pages-fix-2.patch added to -mm tree
Date: Wed, 11 Mar 2020 17:51:00 -0700
Message-ID: <20200311175100.1614d82ae9ac21b73d922870@linux-foundation.org>
References: <20200307232517.0eSNFUWfN%akpm@linux-foundation.org>
        <202efdc4-2b19-278b-9960-3afb18b8173d@nvidia.com>
        <20200311111352.1dff2984@p-imbrenda>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387519AbgCLAvB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 20:51:01 -0400
In-Reply-To: <20200311111352.1dff2984@p-imbrenda>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>, mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>

On Wed, 11 Mar 2020 11:13:52 +0100 Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> > any case, that's what this needs in order to build. Sorry for missing
> > it in the review.
> 
> I don't think you missed it, because the patch I sent out to be
> squashed did move it up

<figures out what happened>

hm, OK,
http://lkml.kernel.org/r/20200306132537.783769-2-imbrenda@linux.ibm.com
is billed as a fixup for 9947ea2c1e608e32 "mm/gup: track FOLL_PIN
pages" but it actually applies after everything else.  I messed up
untangling this.

Redone, should be OK now.
