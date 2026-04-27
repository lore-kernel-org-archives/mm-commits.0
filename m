Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF743BA24E
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294514; cv=none; b=EVR8apeKLYvEDUOzoRlFfXw87Or5YKm7vIRzScIjy8hP34QQ7cFc1lxHbrm8xoDMJLednkZh/BlHupxgw1aFGNkv8nMfaKxnVLU9EU+UwnQ1+zUZuZWHT5LEcaBDRhq7EHKcQD93N6RUn1ewDjmGXa70MnNsAsVbUa9wtpgmszI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294514; c=relaxed/simple;
	bh=0mXIh/JFwazY0/lHCShjP1l7CBfRuoGGlJKXe4IT7NQ=;
	h=Date:To:From:Subject:Message-Id; b=Cu18UbxstRqj+gxN3/8MFWxlm9TUTeXMNA9cXt+PL7ddEBGFtAi/dQmXRZuougtqh3WCeh7ukoyLd2e9O+l1C9Rro93yn1sUE0jIBJ6G5ZnyxpsYkPZILImbXhvDnNNhPk7YQagOIb9Lzqfw8Je0twhQfZCV9ArfFmjCnImsSbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5liSWDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5liSWDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2E7C2BCB4;
	Mon, 27 Apr 2026 12:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294514;
	bh=0mXIh/JFwazY0/lHCShjP1l7CBfRuoGGlJKXe4IT7NQ=;
	h=Date:To:From:Subject:From;
	b=q5liSWDOguviISgtKurgOe7dVFb8sYWufWcBj2O/399kPsq894YJOEufrVEGbzMKe
	 jiGSL7GPylkZmbLjS+TcJb2eZF2UPuPlKKCq07BA2J3V2AtTnszt4AnDQ5SkXJBldL
	 eaVwZyrkDPtyQ/ZioHh56FFTTDu9lRaZ/1C1T0B4=
Date: Mon, 27 Apr 2026 05:55:13 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,pvorel@suse.cz,martink@posteo.de,liwang@redhat.com,kuba@kernel.org,chrubis@suse.cz,arnd@arndb.de,li.wang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-li-wangs-email-address.patch removed from -mm tree
Message-Id: <20260427125514.5D2E7C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update Li Wang's email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-li-wangs-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <li.wang@linux.dev>
Subject: MAINTAINERS: update Li Wang's email address
Date: Thu, 23 Apr 2026 21:26:49 +0800

Update my email address as my work email account is no longer in use. 
Also update .mailmap.

Link: https://lore.kernel.org/20260423132649.31126-1-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Li Wang <liwang@redhat.com>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    2 ++
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-li-wangs-email-address
+++ a/.mailmap
@@ -507,6 +507,8 @@ Linus Walleij <linusw@kernel.org> <linus
 Linus Walleij <linusw@kernel.org> <linus.walleij@linaro.org>
 Linus Walleij <linusw@kernel.org> <triad@df.lth.se>
 <linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
+Li Wang <li.wang@linux.dev> <liwang@redhat.com>
+Li Wang <li.wang@linux.dev> <wangli.ahau@gmail.com>
 Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
 Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
 Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
--- a/MAINTAINERS~maintainers-update-li-wangs-email-address
+++ a/MAINTAINERS
@@ -15252,7 +15252,7 @@ M:	Andrea Cervesato <andrea.cervesato@su
 M:	Cyril Hrubis <chrubis@suse.cz>
 M:	Jan Stancek <jstancek@redhat.com>
 M:	Petr Vorel <pvorel@suse.cz>
-M:	Li Wang <liwang@redhat.com>
+M:	Li Wang <li.wang@linux.dev>
 M:	Yang Xu <xuyang2018.jy@fujitsu.com>
 M:	Xiao Yang <yangx.jy@fujitsu.com>
 L:	ltp@lists.linux.it (subscribers-only)
_

Patches currently in -mm which might be from li.wang@linux.dev are

selftests-cgroup-skip-test_zswap-if-zswap-is-globally-disabled.patch
selftests-cgroup-avoid-oom-in-test_swapin_nozswap.patch
selftests-cgroup-use-runtime-page-size-for-zswpin-check.patch
selftests-cgroup-rename-page_size-to-buf_size-in-cgroup_util.patch
selftests-cgroup-replace-hardcoded-page-size-values-in-test_zswap.patch
selftest-cgroup-fix-zswap-test_no_invasive_cgroup_shrink-on-large-pagesize-system.patch
selftest-cgroup-fix-zswap-attempt_writeback-on-64k-pagesize-system.patch
selftests-cgroup-test_zswap-wait-for-asynchronous-writeback.patch

