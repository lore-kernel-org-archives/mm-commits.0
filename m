Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09B2C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 02:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B60723A55
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 02:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgLHCHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 21:07:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgLHCHG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 21:07:06 -0500
Date:   Mon, 7 Dec 2020 18:06:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607393186;
        bh=msmHrwmlh1qFvOZdVXE4ngmUyILmuClmjdkwhwi30/E=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1p2CtacQauC+yeMhas+45ltCeOtr8jJ+LPPzlBjK2c+hkZJbqQJqGPxFPcHcmtRx
         Ja/HgAoeWb8wqN+xlQXhAr7bGFc9AEgHGybajAnJcy/KYqwI8jo5Z8nMDPHUUtC7Xy
         ewtWx2oAA3moIbcrLuWYcwCCfJPwMYP+zWDsV3Qo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Oscar Salvador <osalvador@suse.de>
Cc:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com
Subject: Re: + mmhwpoison-refactor-get_any_page.patch added to -mm tree
Message-Id: <20201207180625.869509a2917f587e78656eb3@linux-foundation.org>
In-Reply-To: <ee314e5120ae9b988c190e20ff1310d8@suse.de>
References: <20201120235853.WbRjfie04%akpm@linux-foundation.org>
        <ee314e5120ae9b988c190e20ff1310d8@suse.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 07 Dec 2020 10:52:29 +0100 Oscar Salvador <osalvador@suse.de> wrote:

> On 2020-11-21 00:58, akpm@linux-foundation.org wrote:
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> > 
> > ------------------------------------------------------
> > From: Oscar Salvador <osalvador@suse.de>
> > Subject: mm,hwpoison: refactor get_any_page
> > 
> > Patch series "HWPoison: Refactor get page interface"
> 
> Hi Andrew,
> 
> I saw that you already pulled [1] (v2 of this patchset) into mmotm.
> I am not sure if you dropped this v1 from mmotm, but if not, would you 
> be so kind to do so?
> 

Yes, I silently dropped v1.  Believe it or not, I do try to constrain
the amount of email I spray at people ;)

