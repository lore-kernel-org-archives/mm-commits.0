Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B649C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E3F610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347532AbhIBVu6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347538AbhIBVu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2723960F12;
        Thu,  2 Sep 2021 21:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619399;
        bh=1b/qhZneFbZ/7zeAmw88QZpYIViTYWEVeG4MzdJCMrc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fcCeJNHdvpIcEQrWbyZnwvXp8hnB1reYjAX2rYP4q1vKPH6+qcVuWG3RWjyhQppdK
         U9nICshAIQiaoh4JLxudlzdxPywO/qdMRcpDYi8/h2xl+3q7y/jAU15atKZexfSxLZ
         mlWPPprBDK+QbUSHQpHw/qUJs0iHr+mxNBiiu8EM=
Date:   Thu, 02 Sep 2021 14:49:58 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        wangborong@cdjrlc.com
Subject:  [patch 001/212] ia64: fix typo in a comment
Message-ID: <20210902214958.oq4_CI4X3%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jason Wang <wangborong@cdjrlc.com>
Subject: ia64: fix typo in a comment

s/when when/when/

Link: https://lkml.kernel.org/r/20210817112500.12848-1-wangborong@cdjrlc.com
Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/kernel/acpi.c~ia64-fix-typo-in-a-comment
+++ a/arch/ia64/kernel/acpi.c
@@ -906,6 +906,6 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
 /*
  * acpi_suspend_lowlevel() - save kernel state and suspend.
  *
- * TBD when when IA64 starts to support suspend...
+ * TBD when IA64 starts to support suspend...
  */
 int acpi_suspend_lowlevel(void) { return 0; }
_
