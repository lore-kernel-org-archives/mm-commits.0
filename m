Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DA9C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 18:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbiCWSQ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 14:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiCWSQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 14:16:27 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB451FCD0
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 11:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pLzC/IHt7BEKdj4U9paKcllOLq0ll96Uxs8Nz++o3aI=; b=NGwYYkJDRdeNihmyQp6CovYpae
        4waoY42Y6JewhrbW1iUggjjVOCz1/fT5CAw6wAANG+J3nxEU3uhIU7suyENBVz00oerF3ftj4lbUT
        fndr6cK13LMTtRBNdaEsIHSyiobTaxGnRnu0LpvHQ82JWgeU2o232BKO5rPet66qv1tvh3GnTC+xM
        vwM3KyzDuQlU0+DNGp30Tb+MYH8WeAcfUiCVdFXupbPvrIuJIRaKGuD/B9hvlx1A5B866RXhXNWbH
        F0Ci8i4OFgqXl/0iQ1oUkZKGxb+DFEFy0YXlG86l7NzjES+rkbdGFT/vyudEcGCSplQs2hRR3kqrv
        6BVqaqTQ==;
Received: from [187.39.124.208] (helo=[192.168.0.110])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nX5VT-0001QG-1J; Wed, 23 Mar 2022 19:14:51 +0100
Message-ID: <c7018094-c892-587a-5a02-47ad95a00f5a@igalia.com>
Date:   Wed, 23 Mar 2022 15:14:37 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: + panic-move-panic_print-before-kmsg-dumpers.patch added to -mm
 tree
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, bhe@redhat.com, feng.tang@intel.com,
        pmladek@suse.com, senozhatsky@chromium.org
References: <20220228185002.EF7D1C340F1@smtp.kernel.org>
 <6a5bbbfd-3071-20dd-80b9-0e3bda3122ce@igalia.com>
 <20220323092815.cc84a802d11985996c35cfb0@linux-foundation.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220323092815.cc84a802d11985996c35cfb0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 23/03/2022 13:28, Andrew Morton wrote:
> On Wed, 23 Mar 2022 11:23:39 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> [...] 
>> Hi Andrew, I'd like to ask you if it's possible to merge this patch (and
>> also [0]) for 5.18. I've checked Linus tree as for today and it's not
>> there, I hope there is still time.
>>
> 
> Yes, it's in the queue.

Thanks a lot, much appreciated!
