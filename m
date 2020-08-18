Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFAAC433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E0B9207DA
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 22:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597790424;
	bh=OfDqyTdtn5EIFCJf4Yd0VX4dkneXr6TCivPwjKop8Tc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JTtB4KU26ZQ/IJTt7gPGgJJAsQcQItoeX00KvrgbaoNIesKg5wFs4dtoDT2b7JG3/
	 WU4y6dJdUNhaGKsOajCzZEqX+LLvLv5wRa5uSTHL7KipEMP3Y1rj8pCjwqiJHdMz5O
	 kSuMVzEaJHgneNJO+7uNO6jni2j2imkuJZJjt7SI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHRWkV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726972AbgHRWkT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 18:40:19 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7149720709;
        Tue, 18 Aug 2020 22:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597790419;
        bh=OfDqyTdtn5EIFCJf4Yd0VX4dkneXr6TCivPwjKop8Tc=;
        h=Date:From:To:Subject:From;
        b=LnYvmZmJiho2AoXd8hrIAIZ+mnsF+B7YaCTQ4MzvTN6YoMOpQexGK813pAWBopBNI
         rnDAknJ13MG3qdRVQ9VO4Q98x5Y9UhpfhwXhskMPLmael4IFpd9SgfN+6tMXUt84ir
         uyvUV0vuOlAcnaOEkmVdDuj3EiD3A4QLl32P2zm8=
Date:   Tue, 18 Aug 2020 15:40:19 -0700
From:   akpm@linux-foundation.org
To:     groug@kaod.org, mm-commits@vger.kernel.org
Subject:  [merged] mailmap-add-entry-for-greg-kurz.patch removed
 from -mm tree
Message-ID: <20200818224019.93fLeKWKV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Greg Kurz
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-greg-kurz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Kurz <groug@kaod.org>
Subject: mailmap: add entry for Greg Kurz

I had stopped using gkurz@linux.vnet.ibm.com a while back already but this
email address was shutdown last June when I quit IBM.  It's about time to
map it to groug@kaod.org.

Link: http://lkml.kernel.org/r/159724692879.76040.4938578139173154028.stgit@bahia.lan
Signed-off-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-greg-kurz
+++ a/.mailmap
@@ -104,6 +104,7 @@ Gerald Schaefer <gerald.schaefer@linux.i
 Greg Kroah-Hartman <greg@echidna.(none)>
 Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
+Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
_

Patches currently in -mm which might be from groug@kaod.org are


