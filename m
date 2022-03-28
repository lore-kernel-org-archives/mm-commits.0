Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7CDC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 22:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbiC1WUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiC1WUG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 18:20:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E737C3BF93
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 15:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HNSVWa9uiqxAzi8VGq+iQffCNtKmSw38KqNh5IUVczI=; b=E/qcgp2e9IbaFsl8I31VtqnGEy
        Xp6JMVcaO29I5w2zSXP/7N8g0D0I0ngJJPs4jjvJeId8GeLVajLNXtmmEk1KU7cNAUeZlzFFNNFxy
        ZjHHG0o596LjTiD1iV8czgesFUFoYX5onVwzMAbWafVW/fOZhK5rXsMEcmHVs6mMg+cajyVW+OxoV
        boIk8QXdBV7/KIoRLYu4Okcv23MAw+zIqgRlg+uFTYM148Z7hJAE5Qh1hHH1QSdRgJ1ImW+124AqH
        qGtx4YH+/KoolEj7uF7N+cwsrMuQ9RbgBi3GfZozoepfFOicjppcgmOD8TlKbuzoG/ed+OTcf0G5J
        ShotM9Kg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nYxJa-00HIhi-Hd; Mon, 28 Mar 2022 21:54:18 +0000
Date:   Mon, 28 Mar 2022 22:54:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, sfr@canb.auug.org.au,
        hughd@google.com
Subject: Re: + mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch added
 to -mm tree
Message-ID: <YkIuiitlQZaWi2Zn@casper.infradead.org>
References: <20220328200937.AE5C2C340ED@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328200937.AE5C2C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Mar 28, 2022 at 01:09:36PM -0700, Andrew Morton wrote:
> 
> The patch titled
>      Subject: mm/munlock: remove fields to fix htmldocs warnings
> has been added to the -mm tree.  Its filename is
>      mm-munlock-remove-fields-to-fix-htmldocs-warnings.patch

Ugh, no, I'll fix the kernel-doc.
