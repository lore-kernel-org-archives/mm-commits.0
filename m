Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001AAC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCAA52065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027138;
	bh=4BOgnUlZBa/S9R7793n7pyD3xn+MlVYIBMC1l4nf1bA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=nIK88RJCqiMtgW6V3ugv7zrTydARVt45XbQ+WP0xRy+IoS3sZAbjJLhhuJCzbaFQk
	 tAWoS78xWuEoyY7uWrr2e/s5wM72OvdO7bbqM7tCxUY7SK+PeHv7VLZ7cnkpXfdNUu
	 KdRqmA/pklmGe4BGPlbSdCrtY7+jBuFtaI+L8g0A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHJCi6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgHJCi6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:38:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D302065D;
        Mon, 10 Aug 2020 02:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027137;
        bh=4BOgnUlZBa/S9R7793n7pyD3xn+MlVYIBMC1l4nf1bA=;
        h=Date:From:To:Subject:From;
        b=q3dkoKY48dvgmF1Nj1/O2NpxgiLmzUHecfsdmS7VyUYaydFxAs8qAjiQq4GBAaiFR
         /4smY9Vj20HhxFVrdItpClfQnPoXxlxwvvdRDDDZuhHqZ319LD1gdcSjD2ATa4kuQz
         8sruzQjAHFl46NF36RpV8nblGTyfBrd9VOjRUBUY=
Date:   Sun, 09 Aug 2020 19:38:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        urezki@gmail.com
Subject:  [merged]
 mm-vmalloc-update-the-header-about-kva-rework.patch removed from -mm tree
Message-ID: <20200810023857.oZeRXxBC1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: update the header about KVA rework
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-update-the-header-about-kva-rework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: update the header about KVA rework

Reflect information about the author, date and year when the KVA rework
was done.

Link: http://lkml.kernel.org/r/20200622195821.4796-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-update-the-header-about-kva-rework
+++ a/mm/vmalloc.c
@@ -7,6 +7,7 @@
  *  SMP-safe vmalloc/vfree/ioremap, Tigran Aivazian <tigran@veritas.com>, May 2000
  *  Major rework to support vmap/vunmap, Christoph Hellwig, SGI, August 2002
  *  Numa awareness, Christoph Lameter, SGI, June 2005
+ *  Improving global KVA allocator, Uladzislau Rezki, Sony, May 2019
  */
 
 #include <linux/vmalloc.h>
_

Patches currently in -mm which might be from urezki@gmail.com are


