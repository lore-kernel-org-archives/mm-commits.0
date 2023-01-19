Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B305BC46467
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjASWXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjASWWF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:22:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61CCA317C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:07:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 512BA61D66
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2FCC433D2;
        Thu, 19 Jan 2023 22:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674166049;
        bh=ipJzK1OkiN2WdxACuOLDj0HdGNUvaxW8bIUPNlXfgJ4=;
        h=Date:To:From:Subject:From;
        b=iF3TgKX/lZ2XBWFN4yC1GcI+vIukWp8+vNH2OHCKWpbRQx9TO0gQfjRf7G7/Pzm5J
         KtYv+K20fhzDd0aRtUwd3/+sKJcOuAQ2BRPV4pJE3DIcpZ4dsocEjl1hVZWtryP3WG
         tOAlt/uuVL4r433bPJRue+n6fd5i/2E45mChmXyE=
Date:   Thu, 19 Jan 2023 14:07:28 -0800
To:     mm-commits@vger.kernel.org, eugen.hristev@collabora.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-e-mail-address-for-eugen-hristev.patch added to mm-hotfixes-unstable branch
Message-Id: <20230119220729.9A2FCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: update e-mail address for Eugen Hristev
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-e-mail-address-for-eugen-hristev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-e-mail-address-for-eugen-hristev.patch

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
From: Eugen Hristev <eugen.hristev@collabora.com>
Subject: .mailmap: update e-mail address for Eugen Hristev
Date: Thu, 19 Jan 2023 09:22:29 +0200

Update e-mail address.

Link: https://lkml.kernel.org/r/20230119072229.99603-1-eugen.hristev@collabora.com
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mailmap-update-e-mail-address-for-eugen-hristev.patch

