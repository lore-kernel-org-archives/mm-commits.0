Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A563DEB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjGIAag (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjGIAaZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38035E4A
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE43560B68
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA77C433C8;
        Sun,  9 Jul 2023 00:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688862624;
        bh=IH/Dn5B912zWMqTQglzQjwz+NJWACUDYBqYonf3Dm5s=;
        h=Date:To:From:Subject:From;
        b=oa+CoKkt7u5GD+rGAjUGLIUxIITCOadMv493KyVAnlTlUynhVd+bTnFdIYxulZKUC
         pzgwb8RNryadHIcTEE+IT2na9kRzyXGCA2NM05CwtbZfXyGQ79OCJpOunasPiKWNOj
         XIwCSxpbRn5Bub3jztiVUebPyOHhC55zCFzZsvR8=
Date:   Sat, 08 Jul 2023 17:30:23 -0700
To:     mm-commits@vger.kernel.org, msp@baylibre.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-markus-schneider-pargmann.patch removed from -mm tree
Message-Id: <20230709003024.1CA77C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: add Markus Schneider-Pargmann
has been removed from the -mm tree.  Its filename was
     mailmap-add-markus-schneider-pargmann.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Markus Schneider-Pargmann <msp@baylibre.com>
Subject: mailmap: add Markus Schneider-Pargmann
Date: Wed, 28 Jun 2023 10:13:41 +0200

Add my old mail address and update my name.

Link: https://lkml.kernel.org/r/20230628081341.3470229-1-msp@baylibre.com
Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-markus-schneider-pargmann
+++ a/.mailmap
@@ -301,6 +301,7 @@ Marek Behún <kabel@kernel.org> <marek.b
 Marek Behún <kabel@kernel.org> Marek Behun <marek.behun@nic.cz>
 Mark Brown <broonie@sirena.org.uk>
 Mark Starovoytov <mstarovo@pm.me> <mstarovoitov@marvell.com>
+Markus Schneider-Pargmann <msp@baylibre.com> <mpa@pengutronix.de>
 Mark Yao <markyao0591@gmail.com> <mark.yao@rock-chips.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
_

Patches currently in -mm which might be from msp@baylibre.com are


