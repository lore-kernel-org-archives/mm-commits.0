Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70764C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1D82087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816486;
	bh=yEQgnjJGF8mZmA6HUpr98sd1S2pz4++zE+K+bHv1TCA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IAbEtqryJe130GemQUqG5dZsSNg+5j5lRFLwHCo3+3vA3DdkE4qBabm3xGhzocGfg
	 OaFAyoiMz4LMW6Fn11dJnLk9/bp2bbiYtrcdpsv+aGcqOkHUpHUa0XbU0yyC490lS3
	 gEE6fDkj+SYpqWiomG+2TUod0WKXR4KC6rfPNQDE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404358AbgJPCsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD86208C7;
        Fri, 16 Oct 2020 02:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816484;
        bh=yEQgnjJGF8mZmA6HUpr98sd1S2pz4++zE+K+bHv1TCA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=15OtONOYkknAO4h5y51lYSkI3cO+F7/XZaC4Ha5vOibZA/fcNw6O05mVEh8c9Fov7
         ExoafoourLPTyw3JwDkZNl9OzZMxxgo5Yctx1Kw8acqGnsbwCrX+el37YooK22FK+j
         30fqQRy2GSnSpzTvsbCZukpnepb1iWuCyzi95dvQ=
Date:   Thu, 15 Oct 2020 19:48:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 110/156] lib: test_sysctl: delete duplicated words
Message-ID: <20201016024803.q1z1aXq2h%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib: test_sysctl: delete duplicated words

Drop the repeated word "the".

Link: https://lkml.kernel.org/r/20200823040520.1999-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_sysctl.c~lib-test_sysctl-delete-duplicated-words
+++ a/lib/test_sysctl.c
@@ -16,7 +16,7 @@
  */
 
 /*
- * This module provides an interface to the the proc sysctl interfaces.  This
+ * This module provides an interface to the proc sysctl interfaces.  This
  * driver requires CONFIG_PROC_SYSCTL. It will not normally be loaded by the
  * system unless explicitly requested by name. You can also build this driver
  * into your kernel.
_
