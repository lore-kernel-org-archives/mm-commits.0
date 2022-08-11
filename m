Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB782C25B0C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Aug 2022 09:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234070AbiHKJ3R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Aug 2022 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbiHKJ3Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2022 05:29:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86ACF92F54;
        Thu, 11 Aug 2022 02:29:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id ED6AD68AA6; Thu, 11 Aug 2022 11:29:11 +0200 (CEST)
Date:   Thu, 11 Aug 2022 11:29:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220811092911.GA22246@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org> <20220810140030.GA24195@lst.de> <YvP9YITH0RpgpblG@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvP9YITH0RpgpblG@dhcp22.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

This is what I think should solve your problem properly:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma-pool-sizing



