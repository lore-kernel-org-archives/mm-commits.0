Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F161C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E63661404
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 19:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhEMTl6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 15:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhEMTl6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 15:41:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E74F161358;
        Thu, 13 May 2021 19:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620934848;
        bh=K341aaIDpK+udcSQCGhZfp+dqAba1lN+YTSXkjPsulc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xYE/5Wcf8iRbUsBWnSVOr/VB2eJrSgYUIR2Ir1bhxbCw17UBj9Bup8WIE7OkMOBcJ
         4d3jyCZBCz1vFa2fzrjr/CpP0SPqhdk0G/+HzRsOdtKnyd2ftdFVJeEsuAs+krown4
         7u55zDxk3xHIcDmyhIiEMayDCSI6BOAj9I4339C4=
Date:   Thu, 13 May 2021 12:40:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        vdavydov.dev@gmail.com
Subject: Re: +
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch added to -mm
 tree
Message-Id: <20210513124047.aa764aeb5e4dd0af4e00cb01@linux-foundation.org>
In-Reply-To: <2903d6df-b89a-d93b-546d-4944210a6fd8@suse.cz>
References: <20210513003326.ZvcnI0LXP%akpm@linux-foundation.org>
        <2903d6df-b89a-d93b-546d-4944210a6fd8@suse.cz>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 13 May 2021 13:44:29 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> undoing
> mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch
> 
> I guess that wasn't intended?

oop, thanks, sorry, I must have messed up the turn-patch-into-fix-patch
thing.

