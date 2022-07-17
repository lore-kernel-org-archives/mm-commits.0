Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A51FAC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 04:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbiGQEiE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiGQEh7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 00:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B152229E
        for <mm-commits@vger.kernel.org>; Sat, 16 Jul 2022 21:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430C8B8097A
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 04:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF135C341C0;
        Sun, 17 Jul 2022 04:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658032675;
        bh=oNxUMKa+sXn3/80bj73uP3WY38pxU8JzpO+zLF4MW8A=;
        h=Date:To:From:Subject:From;
        b=W+BbKm4RbcXjwXjVpRNYjWy3hbubRk+TqnKvmJPov2ay/NrN7u+o3wO1wCKT+aUz/
         E1ZjsL9b/G12xy/owqm0EdAKwaga3C8hU+7L1k8ely2cPffmCHntoy7lOad6fl8uY5
         mFQlNOdDzYZ1ldM0NaTt31q1Rri7jVAhedz82Fvk=
Date:   Sat, 16 Jul 2022 21:37:54 -0700
To:     mm-commits@vger.kernel.org, sforshee@kernel.org, seth@forshee.me,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-seth-forshees-email-address.patch removed from -mm tree
Message-Id: <20220717043754.DF135C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Seth Forshee's email address
has been removed from the -mm tree.  Its filename was
     mailmap-update-seth-forshees-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Seth Forshee <seth@forshee.me>
Subject: mailmap: update Seth Forshee's email address
Date: Tue, 28 Jun 2022 15:07:34 -0500

seth.forshee@canonical.com is no longer valid, use sforshee@kernel.org
instead.

Link: https://lkml.kernel.org/r/20220628200734.424495-1-sforshee@kernel.org
Signed-off-by: Seth Forshee <sforshee@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-seth-forshees-email-address
+++ a/.mailmap
@@ -368,6 +368,7 @@ Sean Nyekjaer <sean@geanix.com> <sean.ny
 Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
 Sebastian Reichel <sre@kernel.org> <sre@debian.org>
 Sedat Dilek <sedat.dilek@gmail.com> <sedat.dilek@credativ.de>
+Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
 Shuah Khan <shuah@kernel.org> <shuahkhan@gmail.com>
 Shuah Khan <shuah@kernel.org> <shuah.khan@hp.com>
_

Patches currently in -mm which might be from seth@forshee.me are


