Return-Path: <SRS0=RNAI=BY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62AAC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 03:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5DD20715
	for <mm-commits@archiver.kernel.org>; Fri, 14 Aug 2020 03:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597375364;
	bh=Gp/pAPQ62u/rJ3BlMX+S3ZyMKAvvGRl29XzR7ONGhL0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NDxt2Zr/j4JoApirkBRFOjniEcvMcUH9DF1gAWZlirAm1c7X+96ajCthWPMHkFDB6
	 3ylRnFf6F9hY8Xq/uY3nfHQdNk9s0TsxfSO/gNE932pp/k3wxxmArDu/ugQIzV4xpB
	 2TSw15Wmun2EdOqbP7KWw5Jw7NKYnsveMZjS7Cl4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgHNDWo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Aug 2020 23:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgHNDWo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Aug 2020 23:22:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D1220715;
        Fri, 14 Aug 2020 03:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597375363;
        bh=Gp/pAPQ62u/rJ3BlMX+S3ZyMKAvvGRl29XzR7ONGhL0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TrKC7vjer6wSI9JKK41lWpA9BS9f0+GmT+gv09h+xcWzq2TdF+7ab2dOP0+HoqHv1
         AJNgOvGm17bgqAsWCcIJ25Lu5s6uWUvJgLp6fJaXrS4py5uHn9CS6eTs3T4YXm6eyP
         OurkSvLyyw2F9ACr2paRgOExMZu7/Ii7CZnNhjKE=
Date:   Thu, 13 Aug 2020 20:22:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20200814032243.F9borgUFb%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/.mailmap~linux-next-rejects
+++ a/.mailmap
@@ -94,20 +94,22 @@ Felix Kuhling <fxkuehl@gmx.de>
 Felix Moeller <felix@derklecks.de>
 Filipe Lautert <filipe@icewall.org>
 Franck Bui-Huu <vagabon.xyz@gmail.com>
-Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@am.sony.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@sonymobile.com>
+Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Zago <fzago@systemfabricworks.com>
 Gao Xiang <xiang@kernel.org> <gaoxiang25@huawei.com>
 Gao Xiang <xiang@kernel.org> <hsiangkao@aol.com>
-Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@de.ibm.com>
+Gerald Schaefer <gerald.schaefer@linux.ibm.com> <gerald.schaefer@de.ibm.com>
 Gerald Schaefer <gerald.schaefer@linux.ibm.com> <geraldsc@linux.vnet.ibm.com>
 Greg Kroah-Hartman <greg@echidna.(none)>
 Greg Kroah-Hartman <gregkh@suse.de>
 Greg Kroah-Hartman <greg@kroah.com>
 Greg Kurz <groug@kaod.org> <gkurz@linux.vnet.ibm.com>
 Gregory CLEMENT <gregory.clement@bootlin.com> <gregory.clement@free-electrons.com>
+Gustavo Padovan <gustavo@las.ic.unicamp.br>
+Gustavo Padovan <padovan@profusion.mobi>
 Hanjun Guo <guohanjun@huawei.com> <hanjun.guo@linaro.org>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

