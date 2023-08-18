Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555B4EE498E
	for <mm-commits@archiver.kernel.org>; Fri, 18 Aug 2023 20:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356982AbjHRUaT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Aug 2023 16:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379968AbjHRU36 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2023 16:29:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1CE3C22
        for <mm-commits@vger.kernel.org>; Fri, 18 Aug 2023 13:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=clmiT+RW+5fnPcj+Wo+IZRwpSl8P79c2szkmmn1DM/I=; b=P8rcY5j8KF0NTVlpu6gFvizqgf
        +s6sEou+eKSYD+qkmrLIMFYzSrCt8k3X3gKhMNfPF6DeN54z1k9QaTTIemSHFkvnZw3EFgp1E89x3
        eUFofGJRXSh/ZJKb9c+nMhuZTBsDoZ+JSNd3Glco3/YUFIg4mqwMN/vy87NNarMJwTwPA8IJXuLpe
        wHuOdNV/3rasFhn+ZIEKIRYRnvCFLdYiYWUBW/lJZFcjbpBO4cxQg1HCwEbtp/YHIGbK4zB2YqJB6
        MjKwHY7RPuF6OsS/MUSXG3a22J4kWVFlQ/NFJL1L9RVl5HTaxgyOH1m6gyvL7kA+7mvCkb/BVweix
        vRjodhIw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qX66Q-00BUyL-GE; Fri, 18 Aug 2023 20:29:50 +0000
Date:   Fri, 18 Aug 2023 21:29:50 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, hughd@google.com,
        david@redhat.com, peterx@redhat.com
Subject: Re: + mm-wire-up-tail-page-poisoning-over-mappings.patch added to
 mm-unstable branch
Message-ID: <ZN/Uvq1qtlmK25e5@casper.infradead.org>
References: <20230818200031.BC269C433C9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818200031.BC269C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Aug 18, 2023 at 01:00:30PM -0700, Andrew Morton wrote:
> From: Peter Xu <peterx@redhat.com>
> Subject: mm: wire up tail page poisoning over ->mappings
> Date: Tue, 15 Aug 2023 17:06:59 -0400

Did I need to keep NAKing this patch, or did you disagree with my NAK?
