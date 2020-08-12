Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A357B20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266220;
	bh=kfoXR/btRLFGV1GIToaI8uG1u/X2X/HKYdCmLeWy8Tk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qFEQ4Bxo730x/SmMz2O50E8CwdVMUw++onGCB4bCOZMQ+ROLqmnqPsiqCuIAqIRPY
	 UBjEKbN3IpLywIvNzSzJ5S7h2nJWdQG17hXyQHlVmC/YBkx6KBsk0ne9dDX7tMdjmi
	 FrEQtMrvsZIMm0VNIjgR8qk07WsEcUx+HyHPU9Iw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgHLVDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHLVDj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EA232087C;
        Wed, 12 Aug 2020 21:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266219;
        bh=kfoXR/btRLFGV1GIToaI8uG1u/X2X/HKYdCmLeWy8Tk=;
        h=Date:From:To:Subject:From;
        b=T3yWwoXtmhse9IWydN1+fjm5NiBLlUd0z2zX7Al0G02U30/bjZ95fqRE9Szrwv7Sd
         leEFD3g4UjERZb84YljrUuWRQVhYbT1tQ7Q358vLm8h7unoa1jALjksJBMJqdUWsRA
         Mb8eGjFySBs35JQTm/arIZV7BKeK9ni+h6L/US18=
Date:   Wed, 12 Aug 2020 14:03:39 -0700
From:   akpm@linux-foundation.org
To:     lasse.collin@tukaani.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged] xz-drop-duplicated-word-in-linux-xzh.patch
 removed from -mm tree
Message-ID: <20200812210339.NLM1uqVcs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/xz.h: drop duplicated word
has been removed from the -mm tree.  Its filename was
     xz-drop-duplicated-word-in-linux-xzh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/xz.h: drop duplicated word

Drop the doubled word "than" in a comment.

Link: http://lkml.kernel.org/r/05ebba7a-c1e4-01ae-fc7b-15c081b33f3e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Lasse Collin <lasse.collin@tukaani.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xz.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/xz.h~xz-drop-duplicated-word-in-linux-xzh
+++ a/include/linux/xz.h
@@ -28,7 +28,7 @@
  * enum xz_mode - Operation mode
  *
  * @XZ_SINGLE:              Single-call mode. This uses less RAM than
- *                          than multi-call modes, because the LZMA2
+ *                          multi-call modes, because the LZMA2
  *                          dictionary doesn't need to be allocated as
  *                          part of the decoder state. All required data
  *                          structures are allocated at initialization,
_

Patches currently in -mm which might be from rdunlap@infradead.org are


