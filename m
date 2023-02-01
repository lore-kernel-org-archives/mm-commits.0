Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C01C636CC
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjBAApU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjBAApL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:45:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D397E51C6D
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DBB161759
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D9C433D2;
        Wed,  1 Feb 2023 00:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675212305;
        bh=rUpFx0ziEhinT3o2urxVY4zBwhB2PuBRdazdPGuhz00=;
        h=Date:To:From:Subject:From;
        b=fFWpblhTvbOe+vF6fZ9MhLOx1/9dMFOVT4tUp6FC3uwW/vJ7+ClRwszNGzmXYkPBJ
         1O2oII+bOxone2j3QMt2sDpco6uf6woWa6E8JlaUTkyHmS5De25wIhmtJZOj/tVPWR
         0IS0DDZju0nF1UEFSeVWTDisBpakelKEsT2keQ9o=
Date:   Tue, 31 Jan 2023 16:45:05 -0800
To:     mm-commits@vger.kernel.org, eugen.hristev@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-e-mail-address-for-eugen-hristev.patch removed from -mm tree
Message-Id: <20230201004505.C64D9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: .mailmap: update e-mail address for Eugen Hristev
has been removed from the -mm tree.  Its filename was
     mailmap-update-e-mail-address-for-eugen-hristev.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eugen Hristev <eugen.hristev@collabora.com>
Subject: .mailmap: update e-mail address for Eugen Hristev
Date: Thu, 19 Jan 2023 09:22:29 +0200

Update e-mail address.

Link: https://lkml.kernel.org/r/20230119072229.99603-1-eugen.hristev@collabora.com
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-e-mail-address-for-eugen-hristev
+++ a/.mailmap
@@ -130,6 +130,7 @@ Domen Puncer <domen@coderock.org>
 Douglas Gilbert <dougg@torque.net>
 Ed L. Cashin <ecashin@coraid.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
+Eugen Hristev <eugen.hristev@collabora.com> <eugen.hristev@microchip.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> <ezequiel@collabora.com>
 Felipe W Damasio <felipewd@terra.com.br>
_

Patches currently in -mm which might be from eugen.hristev@collabora.com are


