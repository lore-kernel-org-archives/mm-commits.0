Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E013C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6EA020878
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817877;
	bh=pXlR++e6MGYlj+eAGpVntrPgc0SgtZu4NCVt/CEc4JA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=uPtrKC4lhokIhq8RxbOvg32tZKJ73MDENSMZPzjynroPv+SbctAOMimeoVWHcbJX5
	 Pw968MMwhoUP3DpOucjTl7OWH3s3YzeFpaANLAjaqScMQctIsYPNWEmBo+HZL8C0DQ
	 ZiBdg1NA6qquk9Att0EVtp+ZT1LjL02suJKGzGmI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgJPDLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDLR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:11:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E6D820789;
        Fri, 16 Oct 2020 03:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817875;
        bh=pXlR++e6MGYlj+eAGpVntrPgc0SgtZu4NCVt/CEc4JA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=irdw3EvHuRvJHx0HPeTvUNciPNX3WCvEj1TJ0EnWAM1rJniKffnZEtcpL21doXy7B
         m/W9rThlsIZYsbVHdbS84PjC8X2SyCVVS9yjk/0g3dWAAhsafUecoHuevETJucZWsg
         FlbZeQ3V4ITDqDiZmSECmnBk2ICZY2N1ZfKp6svI=
Date:   Thu, 15 Oct 2020 20:11:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 111/156] lib/mpi/mpi-bit.c: fix spello of
 "functions"
Message-ID: <20201016031114.uPKoJSXfI%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
