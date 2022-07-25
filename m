Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D53AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiGYWnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbiGYWnN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22DF2A24E
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5982561419
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17ADC341C6;
        Mon, 25 Jul 2022 22:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658788853;
        bh=I3v1XT32tPMzQmyzMRY8jSZ/rLVZdQL2QM1H2C2i8TU=;
        h=Date:To:From:Subject:From;
        b=lfoGF6F9Q6q6jaw+KBriiLUG+gKrloWAE74kbEgf5mMTH5lkZBlqDcN0k6GVhJkcC
         VGiyDJXb3PhdxSYbnCM0BdGmSubLS5V0Cz1rVFxqmJXVIcJgetUwljwb27rgijpTr0
         5mT8aCT+u8tNF9dZk+rXGW3IxbznKzwzFOwyQ40c=
Date:   Mon, 25 Jul 2022 15:40:53 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, dlatypov@google.com,
        davidgow@google.com, brendan.higgins@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch added to mm-nonmm-unstable branch
Message-Id: <20220725224053.A17ADC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: kunit: Add David Gow as a maintainer of KUnit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Brendan Higgins <brendan.higgins@linux.dev>
Subject: MAINTAINERS: kunit: Add David Gow as a maintainer of KUnit
Date: Mon, 25 Jul 2022 18:07:37 -0400

David has been a de facto maintainer of KUnit for a long time now.
Formalize this in the MAINTAINERS file.

Link: https://lkml.kernel.org/r/20220725220737.790976-1-brendan.higgins@linux.dev
Signed-off-by: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit
+++ a/MAINTAINERS
@@ -10818,6 +10818,7 @@ F:	fs/smbfs_common/
 
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendanhiggins@google.com>
+M:	David Gow <davidgow@google.com>
 L:	linux-kselftest@vger.kernel.org
 L:	kunit-dev@googlegroups.com
 S:	Maintained
_

Patches currently in -mm which might be from brendan.higgins@linux.dev are

mailmap-add-linuxdev-alias-for-brendan-higgins.patch
maintainers-kunit-add-david-gow-as-a-maintainer-of-kunit.patch

