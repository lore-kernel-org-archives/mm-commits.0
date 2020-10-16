Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B8AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93AFA2076C
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881596;
	bh=GL1Eq33UWKh+EakeYZaKDioWFMWStvAhXZW8klC4SzE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Uv7nFQ4YQEFtHQuzSej4e68X1PT+S+fDKdWWppNxCmRgzpJExyWulud1aU7wAGY6o
	 P9KYeUEXe11bQBfYBn6bfffrnowrJT7IkmtlaZouI+phx2rivcYB1n16eXUWv4BSdz
	 yRC/0H9QkZunStyjfZYNEVWIwc4yoJgLMQhaI+vI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409109AbgJPUxQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409095AbgJPUxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:53:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95AD1205CB;
        Fri, 16 Oct 2020 20:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881594;
        bh=GL1Eq33UWKh+EakeYZaKDioWFMWStvAhXZW8klC4SzE=;
        h=Date:From:To:Subject:From;
        b=AxdR5Dh3qFfU+hWK0aBAAJxDwNOvcpLHnM4T6/REcF/lJiR2sbyzVOPhKeHAb7HK9
         VBplh/ccoH71pndIThlqZYhb5BS94iiubzowf/oqSQn1P/HDLZFmDCtehgJTaXUUKT
         7vLjTwzPv5aEpkez1on906aPXkUFxSL98MHfF5RU=
Date:   Fri, 16 Oct 2020 13:53:14 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] lib-mpi-fix-spello-of-functions.patch removed
 from -mm tree
Message-ID: <20201016205314.8GxJhH_Nz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/mpi/mpi-bit.c: fix spello of "functions"
has been removed from the -mm tree.  Its filename was
     lib-mpi-fix-spello-of-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


