Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA37C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1372087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816489;
	bh=pXlR++e6MGYlj+eAGpVntrPgc0SgtZu4NCVt/CEc4JA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=M4monITq5nBQ9DKYKlWH6Ao16sHbCIQNQ6AIn4oyDfXA/7F6PlF77GW0ek14JR+WX
	 rWOVaFuQBfyb1mkh9LD85KpFhI9BFJQ/VOk85bXSi0f4MH46AjEfOeKUX0OSF0UM0c
	 Sfys35z8QpTtKX+c5vxudspIP9rAJeC9YmDy1WRk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404359AbgJPCsJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgJPCsJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:48:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6440208C7;
        Fri, 16 Oct 2020 02:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816487;
        bh=pXlR++e6MGYlj+eAGpVntrPgc0SgtZu4NCVt/CEc4JA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tFha0r6Y4gIztrA+ImPy/Xr5/VD2Ho1pBDR/oVlsSaNOphQcVYNmj9fmf6ztOjboE
         0S4W3M47l5JicoPpXpXV1rmnV90jGK41UkLUkVBn6sNcjVGerSHqDY393T53R+jE7v
         y2ytm0fbM58U/ANMw3pz2wR66VOEPRQisz5utm3o=
Date:   Thu, 15 Oct 2020 19:48:06 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 111/156] lib/mpi/mpi-bit.c: fix spello of
 "functions"
Message-ID: <20201016024806.1CJrNLCeg%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: lib/mpi/mpi-bit.c: fix spello of "functions"

Fix typo/spello of "functions".

Link: https://lkml.kernel.org/r/8df15173-a6df-9426-7cad-a2d279bf1170@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/mpi/mpi-bit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/mpi/mpi-bit.c~lib-mpi-fix-spello-of-functions
+++ a/lib/mpi/mpi-bit.c
@@ -1,4 +1,4 @@
-/* mpi-bit.c  -  MPI bit level fucntions
+/* mpi-bit.c  -  MPI bit level functions
  * Copyright (C) 1998, 1999 Free Software Foundation, Inc.
  *
  * This file is part of GnuPG.
_
