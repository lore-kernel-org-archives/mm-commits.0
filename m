Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DC3C83F2C
	for <mm-commits@archiver.kernel.org>; Sat,  2 Sep 2023 22:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbjIBWSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Sep 2023 18:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjIBWSC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Sep 2023 18:18:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A960CE0
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 15:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96A61CE0159
        for <mm-commits@vger.kernel.org>; Sat,  2 Sep 2023 22:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C65C433C7;
        Sat,  2 Sep 2023 22:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693693076;
        bh=03IiQ09/w8lvaIxyrrIPKlKoNCeZewXj3//jyJJakAs=;
        h=Date:To:From:Subject:From;
        b=kVULhkBX8fBepUYaTHyI+zd0bmpIGtXsVI77tRGpS78z3OAeYcJnRtTC70vPtY6fT
         WIkapl2akc2F6FvczXXypHL4R15N7Wg0awz1CRrz8GGOdmyk8IxwooZguBZlzqh0Ox
         Gfw6WtPtVocDOCxYwDUWFoYRSe36KA3RUatnQUqw=
Date:   Sat, 02 Sep 2023 15:17:55 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, baruch@tkos.co.il,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-rmaph-to-mm-entry.patch removed from -mm tree
Message-Id: <20230902221755.E9C65C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add rmap.h to mm entry
has been removed from the -mm tree.  Its filename was
     maintainers-add-rmaph-to-mm-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baruch Siach <baruch@tkos.co.il>
Subject: MAINTAINERS: add rmap.h to mm entry
Date: Thu, 24 Aug 2023 14:38:09 +0300

Make it easier to figure out where to send patches for this file.

Link: https://lkml.kernel.org/r/efbc7689d35a48ff402644d696aa9a8d8bb6333a.1692877089.git.baruch@tkos.co.il
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-rmaph-to-mm-entry
+++ a/MAINTAINERS
@@ -13622,6 +13622,7 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/mm.h
 F:	include/linux/mmzone.h
 F:	include/linux/pagewalk.h
+F:	include/linux/rmap.h
 F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
_

Patches currently in -mm which might be from baruch@tkos.co.il are


