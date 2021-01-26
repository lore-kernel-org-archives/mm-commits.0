Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A6DC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 17:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D4E20829
	for <mm-commits@archiver.kernel.org>; Tue, 26 Jan 2021 17:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388444AbhAZRX7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Jan 2021 12:23:59 -0500
Received: from foss.arm.com ([217.140.110.172]:53530 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389461AbhAZHio (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 26 Jan 2021 02:38:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 987D331B;
        Mon, 25 Jan 2021 23:31:02 -0800 (PST)
Received: from [192.168.0.130] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0F8B3F68F;
        Mon, 25 Jan 2021 23:31:00 -0800 (PST)
Subject: Re: + mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
 added to -mm tree
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        rafael@kernel.org
References: <20210125230029.J9GtAldi1%akpm@linux-foundation.org>
From:   Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <e17945d3-d402-cc6a-09dc-9183363a89cf@arm.com>
Date:   Tue, 26 Jan 2021 13:01:14 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125230029.J9GtAldi1%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org



On 1/26/21 4:30 AM, akpm@linux-foundation.org wrote:
> 
> The patch titled
>      Subject: mm/memory_hotplug: rename all existing 'memhp' into 'mhp'
> has been added to the -mm tree.  Its filename is
>      mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-rename-all-existing-memhp-into-mhp.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> Subject: mm/memory_hotplug: rename all existing 'memhp' into 'mhp'
> 
> This renames all 'memhp' instances to 'mhp' except for memhp_default_state
> for being a kernel command line option.  This is just a clean up and
> should not cause a functional change.  Let's make it consistent rater than
> mixing the two prefixes.  In preparation for more users of the 'mhp'
> terminology.

Thanks Andrew for updating the commit message here, which I assume
is now complete. But otherwise please do let me know, will be happy
to respin the patch with additional context as mentioned earlier in
the thread.

- Anshuman
