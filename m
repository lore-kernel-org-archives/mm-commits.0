Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED9FC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 20:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E539760ED4
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 20:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhJRUFd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhJRUFd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Oct 2021 16:05:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A439FC06161C
        for <mm-commits@vger.kernel.org>; Mon, 18 Oct 2021 13:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b/kBrc0ot5lotMhj911aYzItr/7+odjJ+lSgUOw7JY0=; b=nOL102VAVFaJE2iClOGxK6B0KK
        gXFSzHO6Zjc4EWQjFGM8hVzsgdIpEMqdQNsU3qUwWrwtnTF96UCvXraIBca9oELfCre5X2qU3Ub62
        EuIcwNLZkYTK+EZ1xDDJqfU19zoq/w4FwtXCv0Tw5Lq15oO9i75uBsg9RCu47HfJ2ix2/XZcnMfdX
        ubeci++2Y05kr5QrOditHjnKexBO5sIaf+bQ0FkA+M8yHlftVmbNFZlaW0HGG9Pmk1G9199tVNkiY
        rhBiVOSvsu2XpHfwrJofRiTEKQ01sUhPOhiiFE1phxL8i8a7zKhnwOvHg2k1gcCQe+CJqlpzKbZJW
        z5d619aQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcYpJ-00BEWP-GC; Mon, 18 Oct 2021 20:02:01 +0000
Date:   Mon, 18 Oct 2021 21:01:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     akpm@linux-foundation.org
Cc:     jiasheng@iscas.ac.cn, mm-commits@vger.kernel.org
Subject: Re: + xarray-fix-xa_to_node-by-adding-xa_is_node.patch added to -mm
 tree
Message-ID: <YW3SpQkvmW+AvuqB@casper.infradead.org>
References: <20211018195830.FrL-KFZEo%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018195830.FrL-KFZEo%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Oct 18, 2021 at 12:58:30PM -0700, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: XArray: fix xa_to_node by adding xa_is_node
> has been added to the -mm tree.  Its filename is
>      xarray-fix-xa_to_node-by-adding-xa_is_node.patch

Please don't.  I forgot to NACK it.
