Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD90C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 29 Jan 2022 04:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352358AbiA2EZk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Jan 2022 23:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiA2EZi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Jan 2022 23:25:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25EBC061714
        for <mm-commits@vger.kernel.org>; Fri, 28 Jan 2022 20:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=klaJI/oEnzxgEBvaKgF3mxtEz2v1eAeJX/++NYpR6eY=; b=GUobRY+wcwuezEOLtJ07QB8+D7
        6akb15+PSy5nY4CDXEFkSMoy2lkn0OZkArDb6lp7FqAthA00bmyiTT2PYcyZsXlEDI4aB9J/avimK
        7zGkag4verV4PNAlHYwz3xp8svjf5Zc88Z0kVKpfGbdq/eQWlVdaqU7m9wr+wRVOqnUpIR9JpDm2o
        7316dgzbyecTb6WX4kmSrOMnqCPOaIXhRerp5+OhqnjWAP3RTK+fnJfJHrqHikyLIBQIoOtnyTGZH
        mMQwoJXp73S3PO0YCLSCxguVfqYTihyZMeJQtmSeNTlzN2h1WfeTUEOH+sRqYgs+0FUMDAijH7fbi
        rBmylO2w==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nDfIr-0077Aa-BH; Sat, 29 Jan 2022 04:25:33 +0000
Date:   Sat, 29 Jan 2022 04:25:33 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: Re: incoming
Message-ID: <YfTBvW4sE1+J5YG3@casper.infradead.org>
References: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128181341.2103de95948608a65958ae40@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jan 28, 2022 at 06:13:41PM -0800, Andrew Morton wrote:
> 12 patches, based on 169387e2aa291a4e3cb856053730fe99d6cec06f.
  ^^

I see 7?
