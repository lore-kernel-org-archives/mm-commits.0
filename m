Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ABD0C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 13:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05C142222D
	for <mm-commits@archiver.kernel.org>; Thu, 14 Jan 2021 13:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhANNTI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Jan 2021 08:19:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:41580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbhANNTI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 14 Jan 2021 08:19:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 88DA3B901;
        Thu, 14 Jan 2021 13:18:26 +0000 (UTC)
Subject: Re: + maintainers-add-myself-as-slab-allocators-maintainer.patch
 added to -mm tree
To:     Pekka Enberg <penberg@iki.fi>, akpm@linux-foundation.org
Cc:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com
References: <20210109005352.MHc5FVVKk%akpm@linux-foundation.org>
 <20210109190845.GA3514837@nero>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <bce75e15-5c3a-0f19-1478-267d08bab204@suse.cz>
Date:   Thu, 14 Jan 2021 14:18:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109190845.GA3514837@nero>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 1/9/21 8:08 PM, Pekka Enberg wrote:

>> ------------------------------------------------------
>> From: Vlastimil Babka <vbabka@suse.cz>
>> Subject: MAINTAINERS: add Vlastimil as slab allocators maintainer
>> 
>> I would like to help with slab allocators maintenance, from the
>> perspective of being responsible for SLAB and more recently also SLUB in
>> an enterprise distro kernel and supporting its users.  Recently I've been
>> focusing on improving SLUB's debugging features, and patch review in the
>> area, including the kmemcg accounting rewrite last year.
>> 
>> Link: https://lkml.kernel.org/r/20210108110353.19971-1-vbabka@suse.cz
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Acked-by: Christoph Lameter <cl@linux.com>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Acked-by: Pekka Enberg <penberg@kernel.org>

Thanks!

Vlastimil
