Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A21C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiFQCMq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379715AbiFQCMa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254164BED
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6719FB8268F
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26840C34114;
        Fri, 17 Jun 2022 02:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431943;
        bh=MmCwWSEytVCngfjsFj5jNjXra3SPfvAvOhfkuXnHZdk=;
        h=Date:To:From:Subject:From;
        b=wLPRSTA/fjuExYqP/9RDrQVkcsq2ieOEiVccBwbp1W/CHgUS/SAa4KV5wGMdQH4L3
         3kx+xI9GBEYSKN8Gz+nt2EYbujuHXfrLtergcLPqsBwper+9+qJ63bpwZ+xgic/2hG
         lOMPcn8h1WOPcTCYSEaSJf6loWxYLLmQA5A6Fs5U=
Date:   Thu, 16 Jun 2022 19:12:22 -0700
To:     mm-commits@vger.kernel.org, lixuefeng@loongson.cn,
        kernel@xen0n.name, jiaxun.yang@flygoat.com, guoren@kernel.org,
        git@xen0n.name, arnd@arndb.de, chenhuacai@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-maillist-information-for-loongarch.patch removed from -mm tree
Message-Id: <20220617021223.26840C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: add maillist information for LoongArch
has been removed from the -mm tree.  Its filename was
     maintainers-add-maillist-information-for-loongarch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


