Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A9EC4321E
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiEJENi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiEJENa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:13:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C1E20AE40
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C94A1B81AF8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C482C385C9;
        Tue, 10 May 2022 04:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652155772;
        bh=ARaxrLXnHFhunGRF0W/5pahwBItiskWyjiYjrS3cKD4=;
        h=Date:To:From:Subject:From;
        b=ESwea1CXafqn0xNMI8iCR9oAgOADecgYEJCiLz3OGmoDdhxWu/ihlX+MS/NQOHQis
         dbF1tI2xmF/ji0KjhyjqVJ7vZQkA/NXbIIrqebMJ5iIXMIGL6Gx99hmDBp3jKtFjRq
         ufmBPvKJeDGMhsoqA6skkwRdLTG8Z19XWp7EyvDI=
Date:   Mon, 09 May 2022 21:09:31 -0700
To:     mm-commits@vger.kernel.org, martyna.szapar-mudlaw@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-martynaszapar-mudlaw-intelcom.patch removed from -mm tree
Message-Id: <20220510040932.6C482C385C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add entry for martyna.szapar-mudlaw@intel.com
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-martynaszapar-mudlaw-intelcom.patch

This patch was dropped because it was merged into mm-hotfixes-stable

------------------------------------------------------
From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Subject: mailmap: add entry for martyna.szapar-mudlaw@intel.com

Separate linux.intel.com account was created for submitting and reviewing
kernel patches, thus need to map previously used primary Intel e-mail
address.

Link: https://lkml.kernel.org/r/20220505132624.41802-1-martyna.szapar-mudlaw@linux.intel.com
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-martynaszapar-mudlaw-intelcom
+++ a/.mailmap
@@ -249,6 +249,7 @@ Mark Yao <markyao0591@gmail.com> <mark.y
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
+Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
 Mathieu Othacehe <m.othacehe@gmail.com>
 Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
 Matthew Wilcox <willy@infradead.org> <matthew@wil.cx>
_

Patches currently in -mm which might be from martyna.szapar-mudlaw@linux.intel.com are


