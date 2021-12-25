Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAABC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 25 Dec 2021 05:12:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhLYFMp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Dec 2021 00:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFMp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Dec 2021 00:12:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CAEC061401
        for <mm-commits@vger.kernel.org>; Fri, 24 Dec 2021 21:12:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D101B80939
        for <mm-commits@vger.kernel.org>; Sat, 25 Dec 2021 05:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CEEC36AE9;
        Sat, 25 Dec 2021 05:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640409163;
        bh=0LopE99UsUzKUNaoGkZZMd2Kbrf1zLP+xyrdFm3haD8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=EJss/6O5n/VAeK8wMmDvqZXalTB5xm4cIdu6D+GKe3wBZt80Q0wr1HRriIRo8CrIg
         6j+3OOOIuXIKnhs7OARXGD653j+ec0HDbd4+42xhyJubSxqHaIRLEG2Tuaxk3LgI3i
         jR8shQjwcqdPkDvpVxtpvFfDfTy+k6fJtBPW00xU=
Date:   Fri, 24 Dec 2021 21:12:42 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexandre.belloni@bootlin.com,
        conor.culhane@silvaco.com, jianjun.wang@mediatek.com,
        linux-mm@kvack.org, miquel.raynal@bootlin.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        ryder.lee@mediatek.com, torvalds@linux-foundation.org
Subject:  [patch 4/9] MAINTAINERS: mark more list instances as
 moderated
Message-ID: <20211225051242.E35cHmAjf%akpm@linux-foundation.org>
In-Reply-To: <20211224211127.30b60764d059ff3b0afea38a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: MAINTAINERS: mark more list instances as moderated

Some lists that are moderated are not marked as moderated consistently, so
mark them all as moderated.

Link: https://lkml.kernel.org/r/20211209001330.18558-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Conor Culhane <conor.culhane@silvaco.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Jianjun Wang <jianjun.wang@mediatek.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-mark-more-list-instances-as-moderated
+++ a/MAINTAINERS
@@ -14845,7 +14845,7 @@ PCIE DRIVER FOR MEDIATEK
 M:	Ryder Lee <ryder.lee@mediatek.com>
 M:	Jianjun Wang <jianjun.wang@mediatek.com>
 L:	linux-pci@vger.kernel.org
-L:	linux-mediatek@lists.infradead.org
+L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	Documentation/devicetree/bindings/pci/mediatek*
 F:	drivers/pci/controller/*mediatek*
@@ -17423,7 +17423,7 @@ F:	drivers/video/fbdev/sm712*
 SILVACO I3C DUAL-ROLE MASTER
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Conor Culhane <conor.culhane@silvaco.com>
-L:	linux-i3c@lists.infradead.org
+L:	linux-i3c@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/devicetree/bindings/i3c/silvaco,i3c-master.yaml
 F:	drivers/i3c/master/svc-i3c-master.c
_
