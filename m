Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1E2C433E1
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F95220657
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 22:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597529533;
	bh=DFfIma9Jr9kQvTbOUHa92NMlePBi95LEQeWnzf21Prg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fC4QY9CU5JfscOq5eD1uYs8xISZCJzznlKtBKAT7YwqSkOYZ88UixLuUZC6B7VUsQ
	 5HSmS24klezCMiUy69EPwpW1r2PE974yIG8nm1UceJjo4gc9kCrK1zfTfnUq8vqdWS
	 bfZYOOJySPaPw+TrsbWT3yKBxwGdxYw8Quwgxk1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgHOWMM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgHOWK2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 15 Aug 2020 18:10:28 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EBD722B43;
        Sat, 15 Aug 2020 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597451421;
        bh=DFfIma9Jr9kQvTbOUHa92NMlePBi95LEQeWnzf21Prg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gukmrL0EW7F8vv5cKA08EshxHLDdhhEBrXiYuUL4yR1G63I1udNrNFwWQjzWhll/o
         5FmcrYPupuKHStkj6ZbCKsm74tK4tw6bhjttZEdEbxUBi9BeTYpcnzjVZG+5Y5WJn9
         V1EXqkgLor2/f1eW4Ppwikf3vlRIRjhZWJkBtRWA=
Date:   Fri, 14 Aug 2020 17:30:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, groug@kaod.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/39] mailmap: add entry for Greg Kurz
Message-ID: <20200815003020.kKSiB4xB6%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
