From: akpm@linux-foundation.org
Subject: - add-mailmap-for-proper-git-shortlog-output.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:46:58 -0800
Message-ID: <200702150846.l1F8kwEl024947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39906 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965352AbXBOIrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nico@cam.org, junkio@cox.net, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     add .mailmap for proper git-shortlog output
has been removed from the -mm tree.  Its filename was
     add-mailmap-for-proper-git-shortlog-output.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: add .mailmap for proper git-shortlog output
=46rom: Nicolas Pitre <nico@cam.org>

This list was built into the git-shortlog tool and has been removed in =
the
latest version.  It should be maintained separately so this is what thi=
s
patch does.

A couple more entries were added to the original list as well.

Signed-off-by: Nicolas Pitre <nico@cam.org>
Acked-by: Junio C Hamano <junkio@cox.net>
Cc: Linus Torvalds <torvalds@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff -puN /dev/null .mailmap
--- /dev/null
+++ a/.mailmap
@@ -0,0 +1,96 @@
+#
+# This list is used by git-shortlog to fix a few botched name translat=
ions
+# in the git archive, either because the author's full name was messed=
 up
+# and/or not always written the same way, making contributions from th=
e
+# same person appearing not to be so or badly displayed.
+#
+# repo-abbrev: /pub/scm/linux/kernel/git/
+#
+
+Aaron Durbin <adurbin@google.com>
+Adam Oldham <oldhamca@gmail.com>
+Adam Radford <aradford@gmail.com>
+Adrian Bunk <bunk@stusta.de>
+Alan Cox <alan@lxorguk.ukuu.org.uk>
+Alan Cox <root@hraefn.swansea.linux.org.uk>
+Aleksey Gorelov <aleksey_gorelov@phoenix.com>
+Al Viro <viro@ftp.linux.org.uk>
+Al Viro <viro@zenIV.linux.org.uk>
+Andreas Herrmann <aherrman@de.ibm.com>
+Andrew Morton <akpm@osdl.org>
+Andrew Vasquez <andrew.vasquez@qlogic.com>
+Andy Adamson <andros@citi.umich.edu>
+Arnaud Patard <arnaud.patard@rtp-net.org>
+Arnd Bergmann <arnd@arndb.de>
+Axel Dyks <xl@xlsigned.net>
+Ben Gardner <bgardner@wabtec.com>
+Ben M Cahill <ben.m.cahill@intel.com>
+Bj=C3=B6rn Steinbrink <B.Steinbrink@gmx.de>
+Brian Avery <b.avery@hp.com>
+Brian King <brking@us.ibm.com>
+Christoph Hellwig <hch@lst.de>
+Corey Minyard <minyard@acm.org>
+David Brownell <david-b@pacbell.net>
+David Woodhouse <dwmw2@shinybook.infradead.org>
+Domen Puncer <domen@coderock.org>
+Douglas Gilbert <dougg@torque.net>
+Ed L. Cashin <ecashin@coraid.com>
+Evgeniy Polyakov <johnpol@2ka.mipt.ru>
+Felipe W Damasio <felipewd@terra.com.br>
+Felix Kuhling <fxkuehl@gmx.de>
+Felix Moeller <felix@derklecks.de>
+Filipe Lautert <filipe@icewall.org>
+Franck Bui-Huu <vagabon.xyz@gmail.com>
+Frank Zago <fzago@systemfabricworks.com>
+Greg Kroah-Hartman <greg@echidna.(none)>
+Greg Kroah-Hartman <gregkh@suse.de>
+Greg Kroah-Hartman <greg@kroah.com>
+Henk Vergonet <Henk.Vergonet@gmail.com>
+Henrik Kretzschmar <henne@nachtwindheim.de>
+Herbert Xu <herbert@gondor.apana.org.au>
+Jacob Shin <Jacob.Shin@amd.com>
+James Bottomley <jejb@mulgrave.(none)>
+James Bottomley <jejb@titanic.il.steeleye.com>
+James E Wilson <wilson@specifix.com>
+James Ketrenos <jketreno@io.(none)>
+Jean Tourrilhes <jt@hpl.hp.com>
+Jeff Garzik <jgarzik@pretzel.yyz.us>
+Jens Axboe <axboe@suse.de>
+Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
+John Stultz <johnstul@us.ibm.com>
+Juha Yrjola <at solidboot.com>
+Juha Yrjola <juha.yrjola@nokia.com>
+Juha Yrjola <juha.yrjola@solidboot.com>
+Kay Sievers <kay.sievers@vrfy.org>
+Kenneth W Chen <kenneth.w.chen@intel.com>
+Koushik <raghavendra.koushik@neterion.com>
+Leonid I Ananiev <leonid.i.ananiev@intel.com>
+Linas Vepstas <linas@austin.ibm.com>
+Matthieu CASTET <castet.matthieu@free.fr>
+Michel D=C3=A4nzer <michel@tungstengraphics.com>
+Mitesh shah <mshah@teja.com>
+Morten Welinder <terra@gnome.org>
+Morten Welinder <welinder@anemone.rentec.com>
+Morten Welinder <welinder@darter.rentec.com>
+Morten Welinder <welinder@troll.com>
+Nguyen Anh Quynh <aquynh@gmail.com>
+Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
+Patrick Mochel <mochel@digitalimplant.org>
+Peter A Jonsson <pj@ludd.ltu.se>
+Praveen BP <praveenbp@ti.com>
+Rajesh Shah <rajesh.shah@intel.com>
+Ralf Baechle <ralf@linux-mips.org>
+Ralf Wildenhues <Ralf.Wildenhues@gmx.de>
+R=C3=A9mi Denis-Courmont <rdenis@simphalempin.com>
+Rudolf Marek <R.Marek@sh.cvut.cz>
+Rui Saraiva <rmps@joel.ist.utl.pt>
+Sachin P Sant <ssant@in.ibm.com>
+Sam Ravnborg <sam@mars.ravnborg.org>
+Simon Kelley <simon@thekelleys.org.uk>
+St=C3=A9phane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
+Stephen Hemminger <shemminger@osdl.org>
+Tejun Heo <htejun@gmail.com>
+Thomas Graf <tgraf@suug.ch>
+Tony Luck <tony.luck@intel.com>
+Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
+Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
_

Patches currently in -mm which might be from nico@cam.org are

origin.patch
git-arm.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
