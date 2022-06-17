Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41BEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379713AbiFQCMa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243043AbiFQCMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE0B64BE3
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73AF861C5E
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C782AC3411A;
        Fri, 17 Jun 2022 02:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431937;
        bh=MV1OwJ15FKCl8KuhOz8kWa1suApD0f+7LLbF4R6f3z4=;
        h=Date:To:From:Subject:From;
        b=NvqBYxRh54YIzKpYGc2Zsy70YH17nvdAnN+zVr3/nUF4AFdDJ6+e6o0Cyp7DG2OxB
         b6oBC2niC9aqfrloz5TsEet86lStiZiZX2hPICPUFmD2kcH1YQbqFrdWycLiPp+GhA
         LJqiANvpS2BdiJeEdrHDNArzSpRhB/rVzQP1bhdo=
Date:   Thu, 16 Jun 2022 19:12:17 -0700
To:     mm-commits@vger.kernel.org, jarkko@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-alias-for-jarkko-profiancom.patch removed from -mm tree
Message-Id: <20220617021217.C782AC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add alias for jarkko@profian.com
has been removed from the -mm tree.  Its filename was
     mailmap-add-alias-for-jarkko-profiancom.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: add alias for jarkko@profian.com
Date: Tue, 7 Jun 2022 19:41:39 +0300

Add alias for patches that I contribute on behalf of Profian
(my current employer).

Link: https://lkml.kernel.org/r/20220607164140.1230876-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-alias-for-jarkko-profiancom
+++ a/.mailmap
@@ -165,6 +165,7 @@ Jan Glauber <jan.glauber@gmail.com> <jan
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are


