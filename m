Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FE4C433E8
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51CD62067D
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 04:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595564138;
	bh=KudJm6zIB8ag4M96K67oG+HSJ+fcHXnwGU1+eoRrNDQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=yIoV7Dy4Hr3/XTQD3bpW1rEsbFyAtRdMixnwa8mALmOs4ZTpbC7HfRHqGRK5y4QPw
	 HMgW7686IRhsI4S7RoAXyDO6YIr3Vmm5Z+fVepcp09F2C0hjTuUJvR2tLy71wDXwhW
	 ucS6wfbv5cEFHrcubMC57ygcGRHp3SdqLKxH+li0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXEPi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:15:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXEPh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 00:15:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABFB2064B;
        Fri, 24 Jul 2020 04:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595564137;
        bh=KudJm6zIB8ag4M96K67oG+HSJ+fcHXnwGU1+eoRrNDQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uu7SLlVniWSPamtTb17v/ugOymZNQflq4wAjnhczBa2ZV8toghzfCv755Wrc5gU7u
         1UGS4S+rcCkdwNK319RdORfHelO4iAs8XJNoce2CJx7Xrq82e8eSeg7AOU3sCs0ww+
         G4w/AVMu2MGlRnp9O0B/qM0Ah2xulmRmt58vM5Tg=
Date:   Thu, 23 Jul 2020 21:15:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 10/15] mailmap: add entry for Mike Rapoport
Message-ID: <20200724041537.GBuxmUviR%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Mike Rapoport <rppt@linux.ibm.com>
Subject: mailmap: add entry for Mike Rapoport

Add an entry to correct my email addresses.

Link: http://lkml.kernel.org/r/20200708095414.12275-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-mike-rapoport
+++ a/.mailmap
@@ -198,6 +198,9 @@ Maxime Ripard <mripard@kernel.org> <maxi
 Mayuresh Janorkar <mayur@ti.com>
 Michael Buesch <m@bues.ch>
 Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Mike Rapoport <rppt@kernel.org> <mike@compulab.co.il>
+Mike Rapoport <rppt@kernel.org> <mike.rapoport@gmail.com>
+Mike Rapoport <rppt@kernel.org> <rppt@linux.ibm.com>
 Miodrag Dinic <miodrag.dinic@mips.com> <miodrag.dinic@imgtec.com>
 Miquel Raynal <miquel.raynal@bootlin.com> <miquel.raynal@free-electrons.co=
m>
 Mitesh shah <mshah@teja.com>
_
