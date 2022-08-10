Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C972FC3F6B0
	for <mm-commits@archiver.kernel.org>; Wed, 10 Aug 2022 18:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiHJSsH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHJSsG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2022 14:48:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D87832F2;
        Wed, 10 Aug 2022 11:48:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5B79134D5E;
        Wed, 10 Aug 2022 18:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660157282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wt1aEccYuJkJn2E+aGUL+JsNFIsKCipNa6xOLmRzdVc=;
        b=XS0ADVxAQCF3Ef+fcg8cFXI1vFJOJbfXP2loSMeil51ka5p5E9Z/ncJ/SPV5WzjjOtQ0gs
        nncyS5RmKTypdlQuiHh5vWph662DpATaED238wKDBPTTM/5NvhG292EJEyTOIq4z3Z20+R
        hUy01qqCxQEp4N2ObJ9NKZBTFv50UUQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7A0013AB3;
        Wed, 10 Aug 2022 18:48:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8aRmKGH982JOJgAAMHmgww
        (envelope-from <mhocko@suse.com>); Wed, 10 Aug 2022 18:48:01 +0000
Date:   Wed, 10 Aug 2022 20:48:00 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        john.p.donnelly@oracle.com, david@redhat.com, bhe@redhat.com
Subject: Re: + dma-pool-do-not-complain-if-dma-pool-is-not-allocated.patch
 added to mm-hotfixes-unstable branch
Message-ID: <YvP9YITH0RpgpblG@dhcp22.suse.cz>
References: <20220810013308.5E23AC433C1@smtp.kernel.org>
 <20220810140030.GA24195@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810140030.GA24195@lst.de>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed 10-08-22 16:00:30, Christoph Hellwig wrote:
> This is really material for the dma-mapping tree (besides the obvious
> coding style problem).

Let me know if I should refresh the patch. I guess you are referring to
80 chars per line here.

> I'll try to unwind through the thread ASAP
> once I've got more burning issues of my plate and will see it it
> otherwise makes sense and pick it up in the proper tree if so.

Thanks.
-- 
Michal Hocko
SUSE Labs
