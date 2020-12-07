Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32821C4361B
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9FA022B3B
	for <mm-commits@archiver.kernel.org>; Mon,  7 Dec 2020 09:53:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgLGJxL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 04:53:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgLGJxL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 04:53:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 550EEACBA;
        Mon,  7 Dec 2020 09:52:30 +0000 (UTC)
MIME-Version: 1.0
Date:   Mon, 07 Dec 2020 10:52:29 +0100
From:   Oscar Salvador <osalvador@suse.de>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com
Subject: Re: + mmhwpoison-refactor-get_any_page.patch added to -mm tree
In-Reply-To: <20201120235853.WbRjfie04%akpm@linux-foundation.org>
References: <20201120235853.WbRjfie04%akpm@linux-foundation.org>
User-Agent: Roundcube Webmail
Message-ID: <ee314e5120ae9b988c190e20ff1310d8@suse.de>
X-Sender: osalvador@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On 2020-11-21 00:58, akpm@linux-foundation.org wrote:
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Oscar Salvador <osalvador@suse.de>
> Subject: mm,hwpoison: refactor get_any_page
> 
> Patch series "HWPoison: Refactor get page interface"

Hi Andrew,

I saw that you already pulled [1] (v2 of this patchset) into mmotm.
I am not sure if you dropped this v1 from mmotm, but if not, would you 
be so kind to do so?

[1] 
https://patchwork.kernel.org/project/linux-mm/cover/20201204102558.31607-1-osalvador@suse.de/

Thanks!

-- 
Oscar Salvador
SUSE L3
