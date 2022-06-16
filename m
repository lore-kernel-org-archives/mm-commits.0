Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF1EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 18:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiFPSgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 14:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiFPSgy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 14:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AE253C55
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 11:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F27B61C4F
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAFBC34114;
        Thu, 16 Jun 2022 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655404612;
        bh=Asr7LUWN9uRL5eckmEGbGsE7n5B0LKKwkckeeEQGBfw=;
        h=Date:To:From:Subject:From;
        b=P3EVAZDunJxIt3bRXmvXIhyuAP0psaQrW76moPYKq2tudH01ndavJT1yhlJERWu7b
         RN536hbbC0dqQo04Yz4rjdd47abqjZq0+oZt3+rz+xDZXOZDPxH38cTbDXtbozkofh
         IAYcKZ1zH4G7BStXJ2jGT5loYBB03sIvRUkJynKs=
Date:   Thu, 16 Jun 2022 11:36:51 -0700
To:     mm-commits@vger.kernel.org, lixuefeng@loongson.cn,
        kernel@xen0n.name, jiaxun.yang@flygoat.com, guoren@kernel.org,
        git@xen0n.name, arnd@arndb.de, chenhuacai@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-maillist-information-for-loongarch.patch added to mm-hotfixes-unstable branch
Message-Id: <20220616183652.5DAFBC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add maillist information for LoongArch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-maillist-information-for-loongarch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-maillist-information-for-loongarch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: MAINTAINERS: add maillist information for LoongArch
Date: Thu, 16 Jun 2022 20:14:56 +0800

Now there is a dedicated maillist (loongarch@lists.linux.dev) for
LoongArch, add it for better collaboration.

Link: https://lkml.kernel.org/r/20220616121456.3613470-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Reviewed-by: WANG Xuerui <git@xen0n.name>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Cc: Guo Ren <guoren@kernel.org>
Cc: Xuerui Wang <kernel@xen0n.name>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-maillist-information-for-loongarch
+++ a/MAINTAINERS
@@ -11591,6 +11591,7 @@ F:	drivers/gpu/drm/bridge/lontium-lt8912
 LOONGARCH
 M:	Huacai Chen <chenhuacai@kernel.org>
 R:	WANG Xuerui <kernel@xen0n.name>
+L:	loongarch@lists.linux.dev
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.git
 F:	arch/loongarch/
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

maintainers-add-maillist-information-for-loongarch.patch

