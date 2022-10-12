Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2E4C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 01:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJLBvs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJLBvq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 21:51:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA78A486D
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 18:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE26261342
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 01:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD60C433D6;
        Wed, 12 Oct 2022 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665539505;
        bh=sLSfWfOLX+0mfw0PaWG64GaiAGQSGiCZjMaQreVZ+ic=;
        h=Date:To:From:Subject:From;
        b=hw60Xwag0kj8AwHac8Pit2u6QY2bVq0/IDv/KaeK3r2EcNnZ5ysAKUfbhW5zYWeIF
         N3pFbhWb72gL14ul1vguMOxb0GK/JkjSud8etYBW/2lQqCCafbipFV5f5SwjUsZr/8
         JtRzejysUFmt0QWQCobpMndLXGSoUhPJfyUUwiGA=
Date:   Tue, 11 Oct 2022 18:51:44 -0700
To:     mm-commits@vger.kernel.org, Tim.Bird@sony.com,
        frank.rowand@sony.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-frank-rowand-email-address.patch removed from -mm tree
Message-Id: <20221012015145.0CD60C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Frank Rowand email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-frank-rowand-email-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank Rowand <frank.rowand@sony.com>
Subject: mailmap: update Frank Rowand email address
Date: Fri, 30 Sep 2022 20:50:09 -0500

Frank is no longer at Sony, add an entry for his latest Sony email

Link: https://lkml.kernel.org/r/20221001015009.3994518-1-frowand.list@gmail.com
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Cc: Tim Bird <Tim.Bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-frank-rowand-email-address
+++ a/.mailmap
@@ -134,6 +134,7 @@ Filipe Lautert <filipe@icewall.org>
 Finn Thain <fthain@linux-m68k.org> <fthain@telegraphics.com.au>
 Franck Bui-Huu <vagabon.xyz@gmail.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@am.sony.com>
+Frank Rowand <frowand.list@gmail.com> <frank.rowand@sony.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@sonymobile.com>
 Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Zago <fzago@systemfabricworks.com>
_

Patches currently in -mm which might be from frank.rowand@sony.com are


