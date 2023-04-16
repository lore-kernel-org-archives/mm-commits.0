Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FB9C77B77
	for <mm-commits@archiver.kernel.org>; Sun, 16 Apr 2023 17:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDPRmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Apr 2023 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDPRmI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Apr 2023 13:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98DA358D
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 10:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC27A61C5E
        for <mm-commits@vger.kernel.org>; Sun, 16 Apr 2023 17:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F27C433D2;
        Sun, 16 Apr 2023 17:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666922;
        bh=ZGUDkjFcDUTP2uRG9RLtMvtwZwDfULcoKnVftamcCM0=;
        h=Date:To:From:Subject:From;
        b=lDbzLaQMV2evV3Ac3jRq1eQ9BQVS6QKOnE+nqqJ0x6tZjReLzNLZhRXYTloSo/H+/
         CkkMT+G63iYvbGGChYuvCkCI9fNBQdK8WxUkPWv9CsT6q+ZItu7PKRCHOdXoCMMUr/
         ffbIOq0XDqno86y9W1UENWGo4lzk6iOKoflOPAQg=
Date:   Sun, 16 Apr 2023 10:42:01 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, colin.i.king@gmail.com,
        jtoppins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-jtoppins-entry-to-reference-correct-email.patch removed from -mm tree
Message-Id: <20230416174202.20F27C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update jtoppins' entry to reference correct email
has been removed from the -mm tree.  Its filename was
     mailmap-update-jtoppins-entry-to-reference-correct-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jonathan Toppins <jtoppins@redhat.com>
Subject: mailmap: update jtoppins' entry to reference correct email
Date: Mon, 10 Apr 2023 17:39:35 -0400

Link: https://lkml.kernel.org/r/d79bc6eaf65e68bd1c2a1e1510ab6291ce5926a6.1681162487.git.jtoppins@redhat.com
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-jtoppins-entry-to-reference-correct-email
+++ a/.mailmap
@@ -232,6 +232,8 @@ Johan Hovold <johan@kernel.org> <johan@h
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
+<jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
+<jon.toppins+linux@gmail.com> <jtoppins@redhat.com>
 Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
_

Patches currently in -mm which might be from jtoppins@redhat.com are


