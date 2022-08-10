Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8CBC00140
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 14:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiHJOAk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 10:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiHJOAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 10:00:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F0361B08;
        Wed, 10 Aug 2022 07:00:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7597D68C7B; Wed, 10 Aug 2022 16:00:31 +0200 (CEST)
Date:   Wed, 10 Aug 2022 16:00:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, hch@lst.de, david@redhat.com,
        bhe@redhat.com, mhocko@suse.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20220810140030.GA24195@lst.de>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810013308.5E23AC433C1@smtp.kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

This is really material for the dma-mapping tree (besides the obvious
coding style problem).  I'll try to unwind through the thread ASAP
once I've got more burning issues of my plate and will see it it
otherwise makes sense and pick it up in the proper tree if so.
