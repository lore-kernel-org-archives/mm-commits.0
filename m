Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794980519;
	b=tRdXAKwHCT/Ut3TkCEIfS9IJT5OnFSo+8scdXCNcf8yFytEUwsdLbar88flJM150BGtz
	 lMOX0YaV1S48Mpno6qd9gSRrRwYFWat4dQ1uzKCYVvlGESfJI+KCsxHIaLs3JFw0K7m/C
	 bX0SdIq8S5KscgVKYwLeMNwRi4Jo7qfxnd1SvGZbIn+6ERTbubuadwTzGJ3g/xsjEAxVu
	 22PYdq5LOPlt5IR2cWIUqxE7JdpWRjtz+EVAqyaTI0zU7XvvrjL2m3+bPRh6/n4B6vLrJ
	 vujCLdiBHlE55smf7dJv6KvwAXUvOSToFDhDN53MuVbzWI7OglkYClxGFnaYrMHmvwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794980519;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=JCfFh3n9dVNh2424JDi6XhNNkqvSSINobYXp3EzaNC4=;
	b=q/yMJCisXK1XdVgI7Uryf1MtgRQDI0tZAJinM4QrWhdcPEe2xJN1LG1zVWi049ES3vge
	 TGYi4Xr3DCdYNpBV4fxZ9Uvrr4dfi7K86XKJQ883wwN2zBtNPSfKWuu7Wsy4PGcwXDe8z
	 luDpukjlujhM8l+yQCzRiy/qGCSMnkwpBgXYCVvobZIntOpUTVifxQwsa4rYnwO8vmHCV
	 z3mjrsSIooKlmb2ymps+z0IzlRYyLa8QjcCgYYHcEPOpzomsjpN+AjMClMCXAHPygyOCS
	 uoAPRsWods5v0ITQwn27afmRTDw3PpLeiZep/PUmGpNaE1OBlrxNLYiBWTjHJBO+Z/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xRLHRIzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5161A606A31C
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 05:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xRLHRIzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F347E1F00934;
	Wed, 18 Nov 2026 05:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794980519;
	bh=JCfFh3n9dVNh2424JDi6XhNNkqvSSINobYXp3EzaNC4=;
	h=Date:To:From:Subject;
	b=xRLHRIzrJaCOkZjia5NkLopxc8XiOfOa5JYzUOfU7xGtYdO2ploSV1b9HbZQrjCOM
	 8XUeoofCo9e2EwPmfEHNhzUTOpiKeLUfE0ZmWqFoRf7TxJ31eHCiXP7WW1IQoyytfe
	 kKYs5uy2jxwhR1G07Lu6Mwdu1tgz7udtoI/CF250=
Date: Tue, 17 Nov 2026 21:41:58 -0800
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,luiz.capitulino@linux.dev,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-hotfixes-stable] mailmap-add-entries-for-luiz-capitulino.patch removed from -mm tree
Message-Id: <20261118054158.F347E1F00934@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mailmap: add entries for Luiz Capitulino
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-luiz-capitulino.patch

This patch was dropped because it was merged into the mm-nonmm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Luiz Capitulino (Red Hat)" <luiz.capitulino@linux.dev>
Subject: mailmap: add entries for Luiz Capitulino
Date: Mon, 16 Nov 2026 16:57:56 -0500

Map my previous addresses to my linux.dev address, which I'll be using for
kernel work going forward.

Link: https://lore.kernel.org/20261116215756.133593-1-luiz.capitulino@linux.dev
Signed-off-by: Luiz Capitulino (Red Hat) <luiz.capitulino@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nico Pache <nico.pache@linux.dev>

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-luiz-capitulino
+++ a/.mailmap
@@ -587,6 +587,9 @@ Lorenzo Stoakes <ljs@kernel.org> <lorenz
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lucas De Marchi <demarchi@kernel.org> <lucas.demarchi@intel.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <lcapitulino@redhat.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <luizcap@amazon.com>
+Luiz Capitulino <luiz.capitulino@linux.dev> <luizcap@redhat.com>
 Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
 Luo Jie <jie.luo@oss.qualcomm.com> <luoj@codeaurora.org>
 Luo Jie <jie.luo@oss.qualcomm.com> <quic_luoj@quicinc.com>
_

Patches currently in -mm which might be from luiz.capitulino@linux.dev are


