From: akpm@linux-foundation.org
Subject: + wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:20:57 -0700
Message-ID: <200803142020.m2EKKwC7017601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbYCNUVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org, khc@pm.waw.pl, paulkf@microgate.com


The patch titled
     wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo* bar" should be "foo *bar"
#135: FILE: drivers/net/wan/hdlc_ppp.c:107:
+static inline struct ppp* get_ppp(struct net_device *dev)

ERROR: "foo* bar" should be "foo *bar"
#141: FILE: drivers/net/wan/hdlc_ppp.c:112:
+static inline struct proto* get_proto(struct net_device *dev, u16 pid)

ERROR: "foo* bar" should be "foo *bar"
#158: FILE: drivers/net/wan/hdlc_ppp.c:128:
+static inline const char* proto_name(u16 pid)

ERROR: "(foo*)" should be "(foo *)"
#178: FILE: drivers/net/wan/hdlc_ppp.c:144:
+	struct hdlc_header *data = (struct hdlc_header*)skb->data;

ERROR: "(foo*)" should be "(foo *)"
#227: FILE: drivers/net/wan/hdlc_ppp.c:177:
+	data = (struct hdlc_header*)skb->data;

WARNING: line over 80 characters
#342: FILE: drivers/net/wan/hdlc_ppp.c:285:
+	{IRC|SCR|3,     INV     , INV ,   INV   , INV ,  INV    ,   INV   }, /* START */

WARNING: line over 80 characters
#343: FILE: drivers/net/wan/hdlc_ppp.c:286:
+	{   INV   ,      0      ,  0  ,    0    ,  0  ,   0     ,    0    }, /* STOP */

WARNING: line over 80 characters
#344: FILE: drivers/net/wan/hdlc_ppp.c:287:
+	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */

ERROR: need space after that ',' (ctx:WxV)
#344: FILE: drivers/net/wan/hdlc_ppp.c:287:
+	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */
 	                        ^

ERROR: need space after that ',' (ctx:WxV)
#344: FILE: drivers/net/wan/hdlc_ppp.c:287:
+	{   INV   ,     INV     ,STR|2,  SCR|3  ,SCR|3,  SCR|5  ,   INV   }, /* TO+ */
 	                                        ^

WARNING: line over 80 characters
#345: FILE: drivers/net/wan/hdlc_ppp.c:288:
+	{   INV   ,     INV     ,  1  ,    1    ,  1  ,    1    ,   INV   }, /* TO- */

WARNING: line over 80 characters
#346: FILE: drivers/net/wan/hdlc_ppp.c:289:
+	{  STA|0  ,IRC|SCR|SCA|5,  2  ,  SCA|5  ,SCA|6,  SCA|5  ,SCR|SCA|5}, /* RCR+ */

ERROR: need space after that ',' (ctx:WxV)
#346: FILE: drivers/net/wan/hdlc_ppp.c:289:
+	{  STA|0  ,IRC|SCR|SCA|5,  2  ,  SCA|5  ,SCA|6,  SCA|5  ,SCR|SCA|5}, /* RCR+ */
 	          ^

ERROR: need space after that ',' (ctx:WxV)
#346: FILE: drivers/net/wan/hdlc_ppp.c:289:
+	{  STA|0  ,IRC|SCR|SCA|5,  2  ,  SCA|5  ,SCA|6,  SCA|5  ,SCR|SCA|5}, /* RCR+ */
 	                                        ^

ERROR: need space after that ',' (ctx:WxV)
#346: FILE: drivers/net/wan/hdlc_ppp.c:289:
+	{  STA|0  ,IRC|SCR|SCA|5,  2  ,  SCA|5  ,SCA|6,  SCA|5  ,SCR|SCA|5}, /* RCR+ */
 	                                                        ^

WARNING: line over 80 characters
#347: FILE: drivers/net/wan/hdlc_ppp.c:290:
+	{  STA|0  ,IRC|SCR|SCN|3,  2  ,  SCN|3  ,SCN|4,  SCN|3  ,SCR|SCN|3}, /* RCR- */

ERROR: need space after that ',' (ctx:WxV)
#347: FILE: drivers/net/wan/hdlc_ppp.c:290:
+	{  STA|0  ,IRC|SCR|SCN|3,  2  ,  SCN|3  ,SCN|4,  SCN|3  ,SCR|SCN|3}, /* RCR- */
 	          ^

ERROR: need space after that ',' (ctx:WxV)
#347: FILE: drivers/net/wan/hdlc_ppp.c:290:
+	{  STA|0  ,IRC|SCR|SCN|3,  2  ,  SCN|3  ,SCN|4,  SCN|3  ,SCR|SCN|3}, /* RCR- */
 	                                        ^

ERROR: need space after that ',' (ctx:WxV)
#347: FILE: drivers/net/wan/hdlc_ppp.c:290:
+	{  STA|0  ,IRC|SCR|SCN|3,  2  ,  SCN|3  ,SCN|4,  SCN|3  ,SCR|SCN|3}, /* RCR- */
 	                                                        ^

WARNING: line over 80 characters
#348: FILE: drivers/net/wan/hdlc_ppp.c:291:
+	{  STA|0  ,    STA|1    ,  2  ,  IRC|4  ,SCR|3,    6    , SCR|3   }, /* RCA */

ERROR: need space after that ',' (ctx:WxV)
#348: FILE: drivers/net/wan/hdlc_ppp.c:291:
+	{  STA|0  ,    STA|1    ,  2  ,  IRC|4  ,SCR|3,    6    , SCR|3   }, /* RCA */
 	                                        ^

WARNING: line over 80 characters
#349: FILE: drivers/net/wan/hdlc_ppp.c:292:
+	{  STA|0  ,    STA|1    ,  2  ,IRC|SCR|3,SCR|3,IRC|SCR|5, SCR|3   }, /* RCN */

ERROR: need space after that ',' (ctx:WxV)
#349: FILE: drivers/net/wan/hdlc_ppp.c:292:
+	{  STA|0  ,    STA|1    ,  2  ,IRC|SCR|3,SCR|3,IRC|SCR|5, SCR|3   }, /* RCN */
 	                              ^

ERROR: need space after that ',' (ctx:VxV)
#349: FILE: drivers/net/wan/hdlc_ppp.c:292:
+	{  STA|0  ,    STA|1    ,  2  ,IRC|SCR|3,SCR|3,IRC|SCR|5, SCR|3   }, /* RCN */
 	                                        ^

ERROR: need space after that ',' (ctx:VxV)
#349: FILE: drivers/net/wan/hdlc_ppp.c:292:
+	{  STA|0  ,    STA|1    ,  2  ,IRC|SCR|3,SCR|3,IRC|SCR|5, SCR|3   }, /* RCN */
 	                                              ^

WARNING: line over 80 characters
#350: FILE: drivers/net/wan/hdlc_ppp.c:293:
+	{  STA|0  ,    STA|1    ,STA|2,  STA|3  ,STA|3,  STA|3  ,ZRC|STA|2}, /* RTR */

ERROR: need space after that ',' (ctx:WxV)
#350: FILE: drivers/net/wan/hdlc_ppp.c:293:
+	{  STA|0  ,    STA|1    ,STA|2,  STA|3  ,STA|3,  STA|3  ,ZRC|STA|2}, /* RTR */
 	                        ^

ERROR: need space after that ',' (ctx:WxV)
#350: FILE: drivers/net/wan/hdlc_ppp.c:293:
+	{  STA|0  ,    STA|1    ,STA|2,  STA|3  ,STA|3,  STA|3  ,ZRC|STA|2}, /* RTR */
 	                                        ^

ERROR: need space after that ',' (ctx:WxV)
#350: FILE: drivers/net/wan/hdlc_ppp.c:293:
+	{  STA|0  ,    STA|1    ,STA|2,  STA|3  ,STA|3,  STA|3  ,ZRC|STA|2}, /* RTR */
 	                                                        ^

WARNING: line over 80 characters
#351: FILE: drivers/net/wan/hdlc_ppp.c:294:
+	{    0    ,      1      ,  1  ,    3    ,  3  ,    5    ,  SCR|3  }, /* RTA */

WARNING: line over 80 characters
#352: FILE: drivers/net/wan/hdlc_ppp.c:295:
+	{  SCJ|0  ,    SCJ|1    ,SCJ|2,  SCJ|3  ,SCJ|4,  SCJ|5  ,  SCJ|6  }, /* RUC */

ERROR: need space after that ',' (ctx:WxV)
#352: FILE: drivers/net/wan/hdlc_ppp.c:295:
+	{  SCJ|0  ,    SCJ|1    ,SCJ|2,  SCJ|3  ,SCJ|4,  SCJ|5  ,  SCJ|6  }, /* RUC */
 	                        ^

ERROR: need space after that ',' (ctx:WxV)
#352: FILE: drivers/net/wan/hdlc_ppp.c:295:
+	{  SCJ|0  ,    SCJ|1    ,SCJ|2,  SCJ|3  ,SCJ|4,  SCJ|5  ,  SCJ|6  }, /* RUC */
 	                                        ^

WARNING: line over 80 characters
#353: FILE: drivers/net/wan/hdlc_ppp.c:296:
+	{    0    ,      1      ,  2  ,    3    ,  3  ,    5    ,    6    }, /* RXJ+ */

WARNING: line over 80 characters
#354: FILE: drivers/net/wan/hdlc_ppp.c:297:
+	{    0    ,      1      ,  1  ,    1    ,  1  ,    1    ,IRC|STR|2}, /* RXJ- */

ERROR: need space after that ',' (ctx:WxV)
#354: FILE: drivers/net/wan/hdlc_ppp.c:297:
+	{    0    ,      1      ,  1  ,    1    ,  1  ,    1    ,IRC|STR|2}, /* RXJ- */
 	                                                        ^

ERROR: do not use assignment in if condition
#440: FILE: drivers/net/wan/hdlc_ppp.c:383:
+	if (!(out = kmalloc(len, GFP_ATOMIC))) {

ERROR: "(foo*)" should be "(foo *)"
#492: FILE: drivers/net/wan/hdlc_ppp.c:433:
+	struct hdlc_header *hdr = (struct hdlc_header*)skb->data;

ERROR: "(foo*)" should be "(foo *)"
#509: FILE: drivers/net/wan/hdlc_ppp.c:450:
+	cp = (struct cp_header*)skb_pull(skb, sizeof(struct hdlc_header));

ERROR: "(foo*)" should be "(foo *)"
#550: FILE: drivers/net/wan/hdlc_ppp.c:491:
+			pid = ntohs(*(__be16*)skb->data);

ERROR: need space after that ',' (ctx:VxV)
#726: FILE: drivers/net/wan/hdlc_ppp.c:665:
+		result = hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
 		                                       ^

total: 28 errors, 13 warnings, 741 lines checked

./patches/wan-new-ppp-code-for-generic-hdlc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Paul Fulghum <paulkf@microgate.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/hdlc_ppp.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/net/wan/hdlc_ppp.c~wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes drivers/net/wan/hdlc_ppp.c
--- a/drivers/net/wan/hdlc_ppp.c~wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes
+++ a/drivers/net/wan/hdlc_ppp.c
@@ -104,12 +104,12 @@ static struct sk_buff_head tx_queue; /* 
 
 static int ppp_ioctl(struct net_device *dev, struct ifreq *ifr);
 
-static inline struct ppp* get_ppp(struct net_device *dev)
+static inline struct ppp *get_ppp(struct net_device *dev)
 {
 	return (struct ppp *)dev_to_hdlc(dev)->state;
 }
 
-static inline struct proto* get_proto(struct net_device *dev, u16 pid)
+static inline struct proto *get_proto(struct net_device *dev, u16 pid)
 {
 	struct ppp *ppp = get_ppp(dev);
 
@@ -125,7 +125,7 @@ static inline struct proto* get_proto(st
 	}
 }
 
-static inline const char* proto_name(u16 pid)
+static inline const char *proto_name(u16 pid)
 {
 	switch (pid) {
 	case PID_LCP:
@@ -141,7 +141,7 @@ static inline const char* proto_name(u16
 
 static __be16 ppp_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
-	struct hdlc_header *data = (struct hdlc_header*)skb->data;
+	struct hdlc_header *data = (struct hdlc_header *)skb->data;
 
 	if (skb->len < sizeof(struct hdlc_header))
 		return htons(ETH_P_HDLC);
@@ -174,7 +174,7 @@ static int ppp_hard_header(struct sk_buf
 #endif
 
 	skb_push(skb, sizeof(struct hdlc_header));
-	data = (struct hdlc_header*)skb->data;
+	data = (struct hdlc_header *)skb->data;
 
 	data->address = HDLC_ADDR_ALLSTATIONS;
 	data->control = HDLC_CTRL_UI;
@@ -380,7 +380,8 @@ static void ppp_cp_parse_cr(struct net_d
 	u8 *opt, *out;
 	unsigned int nak_len = 0, rej_len = 0;
 
-	if (!(out = kmalloc(len, GFP_ATOMIC))) {
+	out = kmalloc(len, GFP_ATOMIC);
+	if (!out) {
 		dev_to_hdlc(dev)->stats.rx_dropped++;
 		return;	/* out of memory, ignore CR packet */
 	}
@@ -430,7 +431,7 @@ static void ppp_cp_parse_cr(struct net_d
 
 static int ppp_rx(struct sk_buff *skb)
 {
-	struct hdlc_header *hdr = (struct hdlc_header*)skb->data;
+	struct hdlc_header *hdr = (struct hdlc_header *)skb->data;
 	struct net_device *dev = skb->dev;
 	struct ppp *ppp = get_ppp(dev);
 	struct proto *proto;
@@ -447,7 +448,7 @@ static int ppp_rx(struct sk_buff *skb)
 	/* Check HDLC header */
 	if (skb->len < sizeof(struct hdlc_header))
 		goto rx_error;
-	cp = (struct cp_header*)skb_pull(skb, sizeof(struct hdlc_header));
+	cp = (struct cp_header *)skb_pull(skb, sizeof(struct hdlc_header));
 	if (hdr->address != HDLC_ADDR_ALLSTATIONS ||
 	    hdr->control != HDLC_CTRL_UI)
 		goto rx_error;
@@ -488,7 +489,7 @@ static int ppp_rx(struct sk_buff *skb)
 	if (pid == PID_LCP)
 		switch (cp->code) {
 		case LCP_PROTO_REJ:
-			pid = ntohs(*(__be16*)skb->data);
+			pid = ntohs(*(__be16 *)skb->data);
 			if (pid == PID_LCP || pid == PID_IPCP ||
 			    pid == PID_IPV6CP)
 				ppp_cp_event(dev, pid, RXJ_BAD, 0, 0,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
revert-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
drivers-media-video-soc_camerac-reads-return-size_t.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
wan-new-ppp-code-for-generic-hdlc-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-sched-make-sure-jiffies-is-up-to-date-before-calling-__update_rq_clock.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-usb-serial-spcp8x5-driver.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
drivers-usb-core-devioc-suppress-warning-with-64k-page_size.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem-checkpatch-fixes.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

