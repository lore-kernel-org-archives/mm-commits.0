Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF8E18EA9
	for <mm-commits@vger.kernel.org>; Fri, 12 Jan 2024 23:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LVF5DWdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786F5C433F1;
	Fri, 12 Jan 2024 23:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705101702;
	bh=uy+nl0RxnVcBJiXHQTHxgYHEt5jj5XPThr8C/3KPpec=;
	h=Date:To:From:Subject:From;
	b=LVF5DWdKO5pofbFbIhHevmO+V7+C2C/Rc5hpOUeQCYsAY2oAdQLxsjoO3hUEQHQZ0
	 lnwqnlRE+9qiBt2v//D40xRBrEiG3dWrCeFfjoqfoW9rw4wBQhWn590HwvgfjNSdKo
	 ltlIHGeFfGdydwWixBQkPADFR/QwhV43F9rY0EYo=
Date: Fri, 12 Jan 2024 15:21:41 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-old-address-mappings-for-myself.patch removed from -mm tree
Message-Id: <20240112232142.786F5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add old address mappings for Randy
has been removed from the -mm tree.  Its filename was
     mailmap-add-old-address-mappings-for-myself.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mailmap: add old address mappings for Randy
Date: Fri, 5 Jan 2024 22:30:44 -0800

Add my old email addresses so that git send-email will map them
to my current email address.

Link: https://lkml.kernel.org/r/20240106063051.13623-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 +++
 1 file changed, 3 insertions(+)

--- a/.mailmap~mailmap-add-old-address-mappings-for-myself
+++ a/.mailmap
@@ -503,6 +503,9 @@ Ralf Baechle <ralf@linux-mips.org>
 Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
 Ram Chandra Jangir <quic_rjangir@quicinc.com> <rjangir@codeaurora.org>
 Randy Dunlap <rdunlap@infradead.org> <rdunlap@xenotime.net>
+Randy Dunlap <rdunlap@infradead.org> <randy.dunlap@oracle.com>
+Randy Dunlap <rdunlap@infradead.org> <rddunlap@osdl.org>
+Randy Dunlap <rdunlap@infradead.org> <randy.dunlap@intel.com>
 Ravi Kumar Bokka <quic_rbokka@quicinc.com> <rbokka@codeaurora.org>
 Ravi Kumar Siddojigari <quic_rsiddoji@quicinc.com> <rsiddoji@codeaurora.org>
 Rémi Denis-Courmont <rdenis@simphalempin.com>
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-win_minmax-fix-header-comments.patch

